{
  inputs,
  ...
}:
{
  flake.modules.homeManager.browser =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
