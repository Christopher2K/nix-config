{
  ...
}:
{
  flake.modules.nixos.gaming =
    { ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
      };
      programs.gamemode.enable = true;
    };
}
