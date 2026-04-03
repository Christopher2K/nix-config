{ inputs, config, ... }:
let
  darwin = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
  helpers = config.flake.helpers;

  # Personal MacBook casks
  macbookCasks = [
    "cleanshot"
    "cyberduck"
    "daisydisk"
    "figma"
    "notion"
    "obs"
    "obsidian"
    "proton-drive"
    "screen-studio"
    "sketch"
    "transmission"
    "virtualbuddy"
  ];

  # Work MacBook (CookUnity) casks
  macbookCookunityCasks = [
    "bezel"
    "cap"
    "cleanshot"
    "elgato-capture-device-utility"
    "elgato-stream-deck"
    "figma"
    "insta360-link-controller"
    "linear-linear"
    "notion"
    "obsidian"
    "proton-drive"
    "switchresx"
    "tuple"
  ];
in
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew

      # system-level configuration
      darwin.ai
      darwin.coding
      darwin.communication
      darwin.homebrew
      darwin.launcher
      darwin.macbookConfiguration
      darwin.security
      darwin.terminal

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
            hm.security
            hm.terminal
            hm.window-manager
          ];
        };
      }
    ];
  };
}
