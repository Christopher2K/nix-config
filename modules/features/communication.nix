{
  inputs,
  ...
}:
{
  flake.modules.homeManager.communication =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vesktop
      ];
    };
}
