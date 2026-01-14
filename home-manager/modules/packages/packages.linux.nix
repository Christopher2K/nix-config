{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./firefox.nix
    ./obs-studio.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    fastfetch
    ffmpegthumbnailer
    gdk-pixbuf
    jq
    libinput
    webp-pixbuf-loader

    # GUI
    mailspring
    nur.repos.Ev357.helium
    nautilus
    vesktop
    vscodium
    obsidian
    polychromatic
    whatsapp-electron
    signal-desktop
  ];
}
