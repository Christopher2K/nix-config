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

    # GUI
    ffmpegthumbnailer
    gdk-pixbuf
    nautilus
    vesktop
    vscodium
    webp-pixbuf-loader
  ];
}
