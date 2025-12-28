{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    inputs.hyprdynamicmonitors.packages.${stdenv.hostPlatform.system}.default
    jq
    hyprpaper

    # GUI
    vesktop
    nautilus
    gdk-pixbuf
    ffmpegthumbnailer
    webp-pixbuf-loader
  ];
}
