{
  config,
  ...
}:
let
  username = config.flake.username;
in
{
  flake.modules.nixos.graphics =
    { config, pkgs, ... }:
    {
      services.xserver.videoDrivers = [
        "amdgpu"
      ];

      environment.systemPackages = with pkgs; [
        pciutils
      ];
    };
}
