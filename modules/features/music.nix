{ config, ... }:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.homeManager.limusic = helpers.mkHybrid {
    linux =
      { pkgs, ... }:
      let
        inherit (import ../software/_limusic.nix pkgs) limusic limusic-desktop;
      in
      {
        home.packages = [
          limusic
          limusic-desktop
        ];
      };
  };
}
