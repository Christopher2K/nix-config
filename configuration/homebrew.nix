{
  config,
  username,
  homebrew-core,
  homebrew-cask,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    mutableTaps = false;
    user = username;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    brews = [
      "libyaml"
      "xcodes"
    ];
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "1password"
      "1password-cli"
      "android-studio"
      "bezel"
      "cleanshot"
      "daisydisk"
      "discord"
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
      "obs"
      "obsidian"
      "screen-studio"
      "signal"
      "sketch"
      "slack"
      "switchresx"
      "transmission"
      "tuple"
      "virtualbuddy"
      "whatsapp"
      "xcodes"
      "zed"
    ];
  };
}
