{
  config,
  inputs,
  pkgs,
  configDest,
  src,
  ...
}:
{
  home.file."${configDest "quickshell"}".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/files/quickshell";

  home.packages = with pkgs; [
    quickshell
  ];
}
