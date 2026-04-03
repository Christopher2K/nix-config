{ inputs, config, ... }:
let
  darwin = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
  helpers = config.flake.helpers;

  # Personal MacBook casks
  macbookCasks = [
    "1password"
    "android-studio"
    "cleanshot"
    "cyberduck"
    "daisydisk"
    "discord"
    "figma"
    "intellij-idea-ce"
    "notion"
    "obs"
    "obsidian"
    "proton-drive"
    "raycast"
    "screen-studio"
    "signal"
    "sketch"
    "transmission"
    "ungoogled-chromium"
    "virtualbuddy"
    "whatsapp"
    "xcodes"
    "zed"
  ];

  # Work MacBook (CookUnity) casks
  macbookCookunityCasks = [
    "1password"
    "android-studio"
    "bezel"
    "cap"
    "cleanshot"
    "elgato-capture-device-utility"
    "elgato-stream-deck"
    "figma"
    "helium-browser"
    "insta360-link-controller"
    "intellij-idea-ce"
    "linear-linear"
    "localcan"
    "loopback"
    "notion"
    "obsidian"
    "proton-drive"
    "raycast"
    "signal"
    "slack"
    "switchresx"
    "tuple"
    "ungoogled-chromium"
    "xcodes"
    "zed"
    "libyaml"
    "xcodes"
  ];
in
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew

      # system-level configuration
      darwin.ai
      darwin.homebrew
      darwin.system

      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          imports = [
            hm.ai
            hm.christopher
            hm.darwinPackages
            hm.security
            hm.window-manager
          ];
        };
      }
    ];
  };
}
