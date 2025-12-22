{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./nvidia.nix
    ./resolutions.nix
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

  # Window manager
  services.xserver.enable = true;
  services.picom.enable = true;
  programs.i3lock.enable = true;
  services.displayManager.defaultSession = "none+i3";
  services.xserver.dpi = 120;
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      i3status
    ];
  };
}
