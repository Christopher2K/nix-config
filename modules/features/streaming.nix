{ config, ... }:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.darwin.streaming = {
    homebrew.casks = [
      "elgato-capture-device-utility"
      "elgato-stream-deck"
      "insta360-link-controller"
      "screen-studio"
    ];
  };

  flake.modules.darwin.streaming-cookunity = {
    homebrew.casks = [
      "screen-studio"
    ];
  };

  flake.modules.homeManager.streaming = helpers.mkHybrid {
    common = {
      programs.obs-studio = {
        enable = true;
      };
    };
  };
}
