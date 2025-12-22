{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Boot options
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amdgpu.modeset=1" "nvidia_drm.modeset=1" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  # Nix configurations
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

  # Networking
  networking.hostName = "razer-nix";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.christopher = {
    isNormalUser = true;
    description = "Christopher Katoyi";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Input blocks
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
  services.libinput.touchpad.disableWhileTyping = true;

  # System packages block
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    firefox
    ghostty
    git
    lshw
    neovim
    pciutils
    polybar
  ];

  # GPU Config
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
        reverseSync.enable = true;
	nvidiaBusId = "PCI:197:0:0";
	amdgpuBusId = "PCI:198:0:0";
      };
    };
  };

  services.displayManager.defaultSession = "none+i3";

  # Window manager
  services.picom.enable = true;
  programs.i3lock.enable = true;
  services.xserver.enable = true;
  services.xserver.dpi = 120;
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [ dmenu i3status ];
  };

  # Screen resolution and management
  services.udev.enable = true;
  services.autorandr = {
    enable = true;
    profiles = {

      capture-card = {
        fingerprint = {
	  eDP = "00ffffffffffff004c83ae410000000000210104b5221678030cf1ae523cb9230c505400000001010101010101010101010101010101000000fe0020202020202020202020202020000000fd0c30f0abab710100000000000000000000fe005344430a202020202020202020000000fc0041544e413630444c30342d3020015c70207902002600090400000000005000002200289a2b1185ff094f0007001f003f06af009d0007009a2b1105ff094f0007001f003f067f156d15070081001f731a0000030b30f000a074026002f0000000008de3058000e60605017460022b000c27003cef00002700303b00002e00060045405e405e00000000000000001e90";
	  HDMI-1-0 = "00ffffffffffff0014e18a000000000009210103803c22780adaffa3584aa22917494ba54f00d1fc81bc3168317c4568457c6168617c08e80030f2705a80b0588a0058522100001e08e8801871382d40582c450058522100001e000000fc004844363020580a202020202020000000fd0014920fa03c000a202020202020015d020356f458906104030201601f1312115f5e5d2221200514070616153f23090707830100006d030c00100038442000600102036ad85dc401788003001478681a00000101147800e30f4238e305e201e6060701000000565e00a0a0a029503020350058522100001e6fc200a0a0a055503020350058522100001a00000000008f";
	};
	config = {
	  eDP = {
	    enable = true;
	    primary = true;
	    position = "0x0";
	    mode = "1920x1080";
	  };
	  HDMI-1-0 = {
	    enable = true;
	    primary = false;
	    position = "0x0";
	    mode = "1920x1080";
	  };
	};
      };

      laptop = {
        fingerprint = {
	  eDP = "00ffffffffffff004c83ae410000000000210104b5221678030cf1ae523cb9230c505400000001010101010101010101010101010101000000fe0020202020202020202020202020000000fd0c30f0abab710100000000000000000000fe005344430a202020202020202020000000fc0041544e413630444c30342d3020015c70207902002600090400000000005000002200289a2b1185ff094f0007001f003f06af009d0007009a2b1105ff094f0007001f003f067f156d15070081001f731a0000030b30f000a074026002f0000000008de3058000e60605017460022b000c27003cef00002700303b00002e00060045405e405e00000000000000001e90";
	};
	config = {
	  eDP = {
	    enable = true;
	    primary = true;
	    position = "0x0";
	    mode = "2560x1600";
	  };
	};
      };
    };
  };

  systemd.user.services.monitor-hotplug = {
    description = "Monitor hotplug safe check";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "check-monitors" ''
	${pkgs.autorandr}/bin/autorandr -c
      ''}";
    };
  };

  systemd.user.timers.monitor-hotplug = {
    description = "Check monitor changes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5s";
      OnUnitActiveSec = "3s";
      Unit = "monitor-hotplug.service";
    };
  };
}
