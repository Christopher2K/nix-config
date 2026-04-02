{ inputs, config, ... }:
let
  universal = config.flakes.universal;
  darwin = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
in
{
  flake.darwinConfigurations.macbook-cookunity = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      # system level configuration

      # home level configuration
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${config.flake.username} = {
          imports = [
            hm.christopher
          ];
        };
      }
    ];
  };
}
