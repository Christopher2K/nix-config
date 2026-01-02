{
  config,
  pkgs,
  configDest,
  ...
}:
{

  home.file."${configDest "nvim"}".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/files/nvim";

  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

}
