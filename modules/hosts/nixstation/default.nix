{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
in
{
  flake.nixosConfigurations.nixstation = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # system level configuration
      nixos.nixstationConfiguration

      nixos."3d-design"
      nixos.coding
      nixos.gaming
      nixos.gnome-apps
      nixos.graphics
      nixos.launcher
      nixos.security
      nixos.splashscreen
      nixos.terminal
      nixos.theme
      nixos.window-manager

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          imports = [
            hm.christopher

            hm.ai
            hm.browser
            hm.cli-tooling
            hm.coding
            hm.communication
            hm.desktop-shell
            hm.gaming
            hm.gnome-apps
            hm.launcher
            hm.notes
            hm.security
            hm.streaming
            hm.terminal
            hm.theme
            hm.window-manager
          ];
        };
      }
    ];
  };
}
