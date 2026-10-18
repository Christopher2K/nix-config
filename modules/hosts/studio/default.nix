{ inputs, config, ... }:
let
  darwin = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
in
{
  flake.darwinConfigurations.studio = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew

      # system-level configuration
      darwin.coding
      darwin.homebrew
      darwin.launcher
      darwin.storage
      darwin.terminal
      darwin.security
      darwin.theme

      darwin.studioConfiguration

      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${username} = {
          imports = [
            hm.christopher
            hm.ai
            hm.cli-tooling
            hm.coding
            hm.terminal
            hm.theme
            hm.security
          ];
        };
      }
    ];
  };
}
