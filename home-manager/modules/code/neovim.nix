{
  pkgs,
  inputs,
  configDest,
  src,
  ...
}:
{
  home.file."${configDest "nvim"}" = {
    source = src "nvim";
    recursive = true;
    force = true;
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

}
