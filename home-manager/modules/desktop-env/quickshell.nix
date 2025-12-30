{
  config,
  inputs,
  pkgs,
  configDest,
  src,
  ...
}:
{
  home.packages = with pkgs; [
    inputs.quickshell.packages.${stdenv.hostPlatform.system}.default
    kdePackages.qtdeclarative
  ];

  home.file."${configDest "quickshell"}".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/files/quickshell";
}
