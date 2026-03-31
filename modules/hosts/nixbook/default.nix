{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.nixbook = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # system level configuration
      nixos.nixbookConfiguration
      nixos.ai
      nixos.coding
      nixos.launcher
      nixos.security
      nixos.terminal
      nixos.window-manager

      # home level configuration
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${config.flake.username} = {
          imports = [
            hm.christopher
            hm.ai
            hm.browser
            hm.cli-tooling
            hm.coding
            hm.launcher
            hm.security
            hm.terminal
            hm.theme
            hm.window-manager
          ];
        };
      }
    ];
  };
}
