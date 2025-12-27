{
  inputs,
  configDest,
  config,
  ...
}:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.file."${configDest "ags"}".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/files/ags";
  programs.ags.enable = true;
}
