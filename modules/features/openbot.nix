{ inputs, ... }:
{
  flake.modules.homeManager.openbot =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.openbot.packages.${pkgs.stdenv.hostPlatform.system}.openbot
      ];
    };
}
