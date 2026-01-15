{
  config,
  username,
  inputs,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    mutableTaps = false;
    user = username;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
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
      "cap"
      "cleanshot"
      "cyberduck"
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
      "raycast"
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
