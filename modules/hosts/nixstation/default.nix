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
      nixos.communication
      nixos.design
      nixos.gaming
      nixos.gnome-apps
      nixos.graphics
      nixos.launcher
      nixos.nix
      nixos.printing
      nixos.remote-access
      nixos.security
      nixos.splashscreen
      nixos.streaming
      nixos.terminal
      nixos.theme
      nixos.window-manager

      nixos.sound
      nixos.rodecaster
      nixos.loupedeck

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          imports = [
            hm.christopher

            hm.ai
            hm.workstation
            hm.browser
            hm.cli-tooling
            hm.coding
            hm.desktop-shell
            hm.gaming
            hm.gnome-apps
            hm.launcher
            hm.limusic
            hm.notes
            hm.security
            hm.storage
            hm.streaming
            hm.terminal
            hm.theme
            hm.window-manager

            hm.sound
            hm.rodecaster
          ];
        };
      }
    ];
  };
}
