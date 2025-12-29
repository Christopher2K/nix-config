{
  inputs,
  pkgs,
  ...
}:
{
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
