{
  pkgs,
  inputs,
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
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
