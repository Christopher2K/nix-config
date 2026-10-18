{ inputs, config, ... }:
let
  helpers = config.flake.helpers;
  tailscaleConfig = {
    services.tailscale = {
      enable = true;
    };
  };
in
{
  flake.modules.nixos.security =
    { pkgs, ... }:
    {
      services.howdy = {
        enable = true;
        settings.core.device = "/dev/video2";
      };
      security.pam.howdy.enable = false;
      security.pam.services.login.enableGnomeKeyring = true;
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.sudo.howdy = {
        enable = true;
        control = "sufficient";
      };
    }
    // tailscaleConfig;

  flake.modules.darwin.security = {
    security.pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
    };
  }
  // tailscaleConfig;

  flake.modules.homeManager.security = helpers.mkHybrid {
    common =
      { pkgs, ... }:
      {
        home.sessionVariables = {
          SSH_AUTH_SOCK = "$HOME/.ssh/proton-pass-agent.sock";
        };

        home.packages = [
          pkgs.proton-pass
          pkgs.proton-pass-cli
        ];
      };

    linux =
      { pkgs, ... }:
      {
        home.sessionVariables = {
          # Temporary fix for https://github.com/NixOS/nixpkgs/issues/497155
          PROTON_PASS_KEY_PROVIDER = "fs";
        };
        systemd.user.sessionVariables = {
          PROTON_PASS_KEY_PROVIDER = "fs";
        };

        systemd.user.services.proton-pass-ssh-agent = {
          Unit = {
            Description = "Proton Pass SSH agent";
            After = [ "default.target" ];
          };
          Service = {
            ExecStart = "${pkgs.proton-pass-cli}/bin/pass-cli ssh-agent start";
            Restart = "on-failure";
            RestartSec = "5s";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };

        systemd.user.services.gnome-keyring-daemon = {
          Unit = {
            Description = "GNOME Keyring daemon";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets,pkcs11";
            Restart = "on-failure";
            RestartSec = "1s";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };

    darwin =
      { pkgs, config, ... }:
      {
        # Auto-start the pass-cli SSH agent daemon at GUI login. Must use the
        # `gui` domain: background (user-domain) agents can't read the pass-cli
        # encryption key from the macOS keychain (errSecInteractionNotAllowed
        # -25308). `daemon start` self-daemonizes and exits (and no-ops with an
        # error if already running), so KeepAlive stays off.
        launchd.agents.pass-cli-ssh-agent = {
          enable = true;
          domain = "gui";
          config = {
            ProgramArguments = [
              "${pkgs.proton-pass-cli}/bin/pass-cli"
              "ssh-agent"
              "daemon"
              "start"
              "--log-file"
              "${config.home.homeDirectory}/Library/Logs/pass-cli-ssh-agent.log"
            ];
            RunAtLoad = true;
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/pass-cli-ssh-agent.log";
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/pass-cli-ssh-agent.log";
          };
        };

        # Fallback for sessions where the launchd agent never fired (SSH-only
        # logins) or can't exist at all (headless hosts rebuilt over SSH, where
        # the gui domain doesn't even exist). Detect a dead agent (ssh-add exit
        # code 2 = cannot connect) and start the daemon from this interactive
        # shell; over SSH the keychain must be unlocked first (prompts once for
        # the login password).
        programs.zsh.initContent = ''
          ssh-add -l &>/dev/null
          if [[ $? -eq 2 ]]; then
            echo "🔑 Proton Pass SSH agent not running — starting it..."
            if [[ -n "$SSH_CONNECTION" ]]; then
              security unlock-keychain
            fi
            ${pkgs.proton-pass-cli}/bin/pass-cli ssh-agent daemon start \
              --log-file "$HOME/Library/Logs/pass-cli-ssh-agent.log"
          fi
        '';
      };
  };
}
