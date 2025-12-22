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
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "590.44.01";
        sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
        sha256_aarch64 = "sha256-gpqz07aFx+lBBOGPMCkbl5X8KBMPwDqsS+knPHpL/5g=";
        openSha256 = "sha256-ft8FEnBotC9Bl+o4vQA1rWFuRe7gviD/j1B8t0MRL/o=";
        settingsSha256 = "sha256-wVf1hku1l5OACiBeIePUMeZTWDQ4ueNvIk6BsW/RmF4=";
        persistencedSha256 = "sha256-nHzD32EN77PG75hH9W8ArjKNY/7KY6kPKSAhxAWcuS4=";
      };
      open = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:197:0:0";
        amdgpuBusId = "PCI:198:0:0";
      };
    };
  };
}
