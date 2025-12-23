{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./nvidia.nix
    ./dm.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
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
      "networkmanager"
      "wheel"
    ];
  };

  # Input blocks
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
  services.libinput.touchpad.disableWhileTyping = true;

  # HyprDynamicMonitors - automatic monitor profile management
  services.hyprdynamicmonitors = {
    enable = true;
    mode = "user"; # Run as user service
  };

  # Required for power/lid events
  services.upower.enable = true;
}
