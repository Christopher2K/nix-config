{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    jq
    libinput
    ffmpegthumbnailer
    gdk-pixbuf
    webp-pixbuf-loader

    # GUI
    nautilus
    vesktop
    vscodium
    obsidian
  ];
}
