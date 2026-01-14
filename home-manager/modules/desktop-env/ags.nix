{
  config,
  inputs,
  pkgs,
  configDest,
  ...
}:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.file."${configDest "ags"}".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/files/ags";

  programs.ags = {
    enable = true;
    extraPackages = [
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.battery
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.network
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.tray
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.apps
      inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.wireplumber
    ];
  };
}
