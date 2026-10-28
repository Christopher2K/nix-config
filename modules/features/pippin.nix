{ inputs, config, ... }:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.homeManager.pippin = helpers.mkHybrid {
    linux =
      { pkgs, ... }:
      {
        home.packages = [
          inputs.pippin.packages.${pkgs.system}.default
        ];
      };
  };
}
