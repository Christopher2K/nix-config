{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    orbstack
    tableplus
    vlc-bin-universal
  ];
}
