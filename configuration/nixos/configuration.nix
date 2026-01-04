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
    ../common.nix
    ./hardware-configuration.nix
    ./programs.nix
    ./nvidia.nix
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

  system.activationScripts.refind-theme = ''
    mkdir -p /boot/EFI/refind/themes
    rm -rf /boot/EFI/refind/themes/refind-theme-regular
    cp -r ${refind-theme-regular} /boot/EFI/refind/themes/refind-theme-regular
  '';

  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };
  boot.kernelParams = [ "quiet" ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  system.stateVersion = "25.11";

  # Some optimization for the garbage collector
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than +10";

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

  # Enable ddcutil for display brightness control
  nix.settings.trusted-users = [
    "root"
    username
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
  services.libinput.touchpad.disableWhileTyping = true;

  hardware.i2c.enable = true;
  hardware.openrazer.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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

  # Various stuff for gnome to be working
  services.gvfs.enable = true; # For trash
  services.udisks2.enable = true; # For mounting removable drives

  # Power management
  services.upower.enable = true;

  # Sound management
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig."51-rodecaster-rename" = {
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
    };
  };

  # services.pulseaudio = {
  #   enable = true;
  #   support32Bit = true;
  #   extraConfig = ''
  #     load-module module-device-manager
  #   '';
  # };
}
