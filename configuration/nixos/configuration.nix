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
  hardware.i2c.enable = true;
  nix.settings.trusted-users = [
    "root"
    username
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
  services.libinput.touchpad.disableWhileTyping = true;

  services.upower.enable = true;
  # Since I'm using Nautilis, I need some gnome related shit
  services.gvfs.enable = true; # For trash
  services.udisks2.enable = true; # For mounting removable drives

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
}
