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
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

}
