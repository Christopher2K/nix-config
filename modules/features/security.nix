{ inputs, ... }:
{
  flake.modules.nixos.security =
    { pkgs, ... }:
    {
      services.gnome.gnome-keyring.enable = true;
      services.howdy.enable = true;
      security.pam.services.login.enableGnomeKeyring = true;
      security.pam.howdy.enable = true;
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

      home.packages = [
        pkgs.proton-pass
        pkgs.proton-pass-cli
      ];
    };
}
