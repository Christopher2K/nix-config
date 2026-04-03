{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
in
{
  flake.nixosConfigurations.nixbook = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # system level configuration
      nixos.ai
      nixos.coding
      nixos.mise-fixes
      nixos.gaming
      nixos.gnome-apps
      nixos.graphics
      nixos.launcher
      nixos.nixbookConfiguration
      nixos.security
      nixos.sound
      nixos.splashscreen
      nixos.terminal
      nixos.theme
      nixos.window-manager

      # home level configuration
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
            hm.mise-fixes
            hm.communication
            hm.desktop-shell
            hm.gaming
            hm.gnome-apps
            hm.launcher
            hm.security
            hm.sound
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
