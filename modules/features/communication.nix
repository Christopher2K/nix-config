{
  config,
  inputs,
  ...
}:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.darwin.communication = {
    homebrew.casks = [
      "whatsapp"
      "signal"
      "slack"
      "insta360-link-controller"
      "zoom"
    ];
  };

  flake.modules.homeManager.communication = helpers.mkHybrid {
    linux = { pkgs, ... }: {
      home.packages = with pkgs; [
        beeper
        discord
        thunderbird
      ];
    };
  };
}
