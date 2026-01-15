{
  config,
  pkgs,
  username,
  ...
}:

let
  refind-theme-regular = pkgs.fetchFromGitHub {
    owner = "bobafetthotmail";
    repo = "refind-theme-regular";
    rev = "master";
    hash = "sha256-gSFSJhW3UjzDAMspSIowbRXLRmrtaO/s1K5qFOWD8Qo=";
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;

  boot.loader.refind = {
    enable = true;
    maxGenerations = 2;
    extraConfig = ''
      timeout 5
      showtools shell, gdisk, memtest, mok_tool, about, reboot, firmware, exit
      include themes/refind-theme-regular/theme.conf
    '';
  };

  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };
  boot.kernelParams = [
    "quiet"
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  system.activationScripts.refind-theme = ''
    mkdir -p /boot/EFI/refind/themes
    rm -rf /boot/EFI/refind/themes/refind-theme-regular
    cp -r ${refind-theme-regular} /boot/EFI/refind/themes/refind-theme-regular
  '';

  system.stateVersion = "25.11";

  # Networking
  networking.hostName = "razer-nix";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.christopher = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Christopher Katoyi";
    extraGroups = [
      "openrazer"
      "networkmanager"
      "wheel"
      "i2c"
    ];
  };

  hardware.i2c.enable = true;
  hardware.openrazer.enable = true;

  services.udev.extraRules = ''
    KERNEL=="card*", KERNELS=="0000:c6:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/amdigpu"
    KERNEL=="card*", KERNELS=="0000:c5:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidiagpu"
    KERNEL=="render*", KERNELS=="0000:c6:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/amdigpurender"
    KERNEL=="render*", KERNELS=="0000:c5:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidiagpurender"
  '';

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'niri-session'";
        user = "greeter";
      };
    };
  };

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
      powerManagement.finegrained = false;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:197:0:0";
        amdgpuBusId = "PCI:198:0:0";
      };
    };
  };

  programs.steam.enable = true;
  programs._1password-gui.enable = true;
  programs.dconf.enable = true;
  programs.nautilus-open-any-terminal.enable = true;
  programs.nautilus-open-any-terminal.terminal = "ghostty";
  services.gnome.sushi.enable = true;
  services.gnome.tinysparql.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    nvtopPackages.amd
  ];

  # Host-specific wireplumber config for Rodecaster
  services.pipewire.wireplumber.extraConfig."51-rodecaster-rename" = {
    "monitor.alsa.rules" = [
      # Outputs
      {
        matches = [ { "node.name" = "alsa_output.usb-R__DE_R__DECaster_Duo-00.pro-output-0"; } ];
        actions = {
          update-props = {
            "node.description" = "Rodecaster Secondary Output";
          };
        };
      }
      {
        matches = [ { "node.name" = "alsa_output.usb-R__DE_RODECaster_Duo_IR0008380-00.pro-output-0"; } ];
        actions = {
          update-props = {
            "node.description" = "Rodecaster Chat Output";
          };
        };
      }
      {
        matches = [ { "node.name" = "alsa_output.usb-R__DE_RODECaster_Duo_IR0008380-00.pro-output-1"; } ];
        actions = {
          update-props = {
            "node.description" = "Rodecaster Main Output";
          };
        };
      }
      # Inputs
      {
        matches = [ { "node.name" = "alsa_input.usb-R__DE_R__DECaster_Duo-00.pro-input-0"; } ];
        actions = {
          update-props = {
            "node.description" = "Rodecaster Secondary Input";
          };
        };
      }
      {
        matches = [ { "node.name" = "alsa_input.usb-R__DE_RODECaster_Duo_IR0008380-00.pro-input-0"; } ];
        actions = {
          update-props = {
            "node.description" = "Rodecaster Chat Input";
          };
        };
      }
      {
        matches = [ { "node.name" = "alsa_input.usb-R__DE_RODECaster_Duo_IR0008380-00.pro-input-1"; } ];
        actions = {
          update-props = {
            "node.description" = "Rodecaster Main Input";
          };
        };
      }
    ];
  };
}
