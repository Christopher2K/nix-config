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
      {
        home.packages = [
          inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
  };
}
