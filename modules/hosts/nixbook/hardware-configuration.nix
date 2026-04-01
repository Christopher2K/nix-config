{
  inputs,
  config,
  ...
}:
{
  flake.nixosModules.nixbookHardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/mapper/luks-8814e771-52e3-403d-ab17-1e04d7a8104a";
        fsType = "ext4";
      };

      boot.initrd.luks.devices."luks-8814e771-52e3-403d-ab17-1e04d7a8104a".device =
        "/dev/disk/by-uuid/8814e771-52e3-403d-ab17-1e04d7a8104a";

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/57E3-3FD4";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/mapper/luks-b38e2595-9210-48d9-8869-601e610db49e"; }
      ];

      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
    };
}
