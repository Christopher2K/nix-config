{
  pkgs,
  configDest,
  config,
  ...
}:
{
  home.file."${configDest "hyprpanel/config.json"}".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/files/hyprpanel/config.json";

  programs.hyprpanel = {
    enable = true;
  };
}
