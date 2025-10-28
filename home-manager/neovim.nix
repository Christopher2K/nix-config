{
  pkgs,
  neovim-nightly-overlay,
  getDest,
  getConfig,
  ...
}:
{
  home.file."${getDest ".config/nvim"}" = {
    source = getConfig "nvim";
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    package = neovim-nightly-overlay.packages.${pkgs.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}