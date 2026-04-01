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
        "nvidia"
      ];

      environment.systemPackages = with pkgs; [
        pciutils
      ];

      hardware.nvidia = {
        nvidiaSettings = true;
        open = true;
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;

        package = config.boot.kernelPackages.nvidiaPackages.production;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          amdgpuBusId = "PCI:101@0:0:0";
          nvidiaBusId = "PCI:100@0:0:0";
        };
      };
    };
}
