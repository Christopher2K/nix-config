{ inputs, ... }:
{
  flake.modules.nixos.security =
    { pkgs, ... }:
    {
      services.howdy = {
        enable = true;
        settings.core.device = "/dev/video2";
      };
      security.pam.services.login.enableGnomeKeyring = true;
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.sudo.howdy = {
        enable = true;
        control = "sufficient";
      };
      security.pam.services.polkit-1.howdy = {
        enable = false;
      };
    };

  flake.modules.homeManager.security =
    { pkgs, ... }:

    {
      home.sessionVariables = {
        SSH_AUTH_SOCK = "$HOME/.ssh/proton-pass-agent.sock";
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

      home.packages = [
        pkgs.proton-pass
        pkgs.proton-pass-cli
      ];
    };
}
