{ inputs, config, ... }:
let
  darwin = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
  helpers = config.flake.helpers;
in
{
  flake.darwinConfigurations.macbook-cookunity = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew

      # system-level configuration
      darwin.ai
      darwin.coding
      darwin.communication
      darwin.design
      darwin.homebrew
      darwin.launcher
      darwin.macbookConfiguration # Same as personal macbook
      darwin.productivity-cookunity
      darwin.security
      darwin.terminal
      darwin.theme

      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          imports = [
            hm.ai
            hm.browser
            hm.christopher
            hm.cli-tooling
            hm.coding
            hm.communication
            hm.notes
            hm.security
            hm.streaming-cookunity
            hm.terminal
            hm.theme
            hm.window-manager
          ];
        };
      }
      {
        homebrew.brews = [
          "tuple"
          "linear-linear"
        ];
      }
    ];
  };
}
