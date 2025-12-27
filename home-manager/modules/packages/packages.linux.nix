{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    inputs.hyprdynamicmonitors.packages.${stdenv.hostPlatform.system}.default
    inputs.astal.packages.${stdenv.hostPlatform.system}.notifd
    jq
    hyprpaper

    # GUI
    vesktop
  ];
}
