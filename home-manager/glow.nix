{
  pkgs,
  neovim-nightly-overlay,
  getDest,
  getConfig,
  ...
}:
{
  home.file."${getDest ".config/glow/glow.yml"}" = {
    source = getConfig "glow/glow.yml";
    recursive = true;
  };
}
