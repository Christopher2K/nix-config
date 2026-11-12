{ config, ... }:
let
  helpers = config.flake.helpers;
in
{
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
