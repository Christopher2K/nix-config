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
    vesktop
    nautilus
    gdk-pixbuf
    ffmpegthumbnailer
    webp-pixbuf-loader
  ];
}
