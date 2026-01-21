{
  pkgs,
  username,
  ...
}:
{
  # Enable ddcutil for display brightness control
  nix.settings.trusted-users = [
    "root"
    username
  ];

  # Keyboard configuration
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
  services.libinput.touchpad.disableWhileTyping = true;

  # Common hardware
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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
    wireplumber.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    brotli
    unixODBC
    libGL
    glib
  ];

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  programs.zsh.enable = true;
  programs.bash.enable = true;
  programs._1password.enable = true;

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    gnupg
    pkg-config
    cmake
    lshw
    pciutils
    unzip
    vim
    pavucontrol
  ];
}
