{
  inputs,
  config,
  ...
}:
{
  flake.modules.darwin.browser = {

    homebrew.casks = [
      "helium-browser"
    ];
  };

  flake.modules.homeManager.browser = config.flake.helpers.mkHybrid {
    linux =
      {
        pkgs,
        ...
      }:
      let
        helium = import ../software/_helium.nix { inherit inputs pkgs; };
      in
      {
        home.packages = [
          helium
        ];
      };
  };
}
