{
  inputs,
  config,
  ...
}:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.homeManager.storage = helpers.mkHybrid {
    linux =
      { pkgs, ... }:
      {
        home.packages = [
          inputs.proton-drive-sync.packages.${pkgs.system}.proton-drive-sync
        ];
      };
  };

  flake.modules.darwin.storage = {
    homebrew.casks = [
      "cyberduck"
      "proton-drive"
      "transmission"
    ];
  };
}
