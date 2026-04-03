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
    "signal"
    "sketch"
    "transmission"
    "virtualbuddy"
    "whatsapp"
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
    "loopback"
    "notion"
    "obsidian"
    "proton-drive"
    "signal"
    "slack"
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
      darwin.homebrew
      darwin.launcher
      darwin.system

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
            hm.window-manager
          ];
        };
      }
    ];
  };
}
