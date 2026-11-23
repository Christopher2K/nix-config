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

  flake.modules.darwin.localsend = {
    homebrew.casks = [ "localsend" ];
  };

  flake.modules.homeManager.localsend = helpers.mkHybrid {
    linux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ localsend ];
      };
  };
}
