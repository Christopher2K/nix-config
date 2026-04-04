{ inputs, config, ... }:
let
  helpers = config.flake.helpers;
  username = config.flake.username;
in
{
  flake.modules.nixos.window-manager =
    { pkgs, ... }:
    {

      nixpkgs.overlays = [
        inputs.niri.overlays.niri
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        # Explicitly map all interfaces to the GNOME backend so niri sessions
        # (which don't advertise a desktop environment) resolve unambiguously.
        config.common.default = "*";
      };

      services.displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
        };

        autoLogin = {
          enable = true;
          user = username;
        };
      };

      programs.niri.enable = true;
    };

  flake.modules.darwin.window-manager =
    { ... }:
    {
      homebrew.casks = [ "omniwm" ];
    };

  flake.modules.homeManager.window-manager = helpers.mkHybrid {
    linux = import ./_window-manager.linux.nix { inherit inputs helpers; };
    darwin = import ./_window-manager.darwin.nix { inherit inputs helpers; };
  };
}
