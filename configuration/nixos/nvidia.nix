{ config, ... }:
{
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.kernelParams = [
    "amdgpu.modeset=1"
    "nvidia_drm.modeset=1"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      nvidiaSettings = true;
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        nvidiaBusId = "PCI:197:0:0";
        amdgpuBusId = "PCI:198:0:0";
      };
    };
  };
}
