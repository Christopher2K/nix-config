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
    jq
    libinput
    ffmpegthumbnailer
    gdk-pixbuf
    webp-pixbuf-loader
    brightnessctl

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
