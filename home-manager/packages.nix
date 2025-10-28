{
  pkgs,
  neovim-nightly-overlay,
  ...
}:
{
  home.packages = with pkgs; [
    # CLI
    bat
    fd
    fzf
    jankyborders
    lazydocker
    lazygit
    lf
    neofetch
    opencode
    ripgrep
    scrcpy
    starship
    tmux
    watchman
    xcodes

    # GUI
    aerospace
    mise
    nixfmt-rfc-style
    orbstack
    raycast
    tableplus
    vlc-bin
    yaak
    zoom-us

    # Nightly stuff
    neovim-nightly-overlay.packages.${pkgs.system}.default
  ];
}
