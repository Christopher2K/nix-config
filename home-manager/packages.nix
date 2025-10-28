{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # CLI
    bat
    fd
    fzf
    lazydocker
    lazygit
    lf
    neofetch
    opencode
    ripgrep
    scrcpy
    watchman
    xcodes

    # GUI
    mise
    nixfmt-rfc-style
    orbstack
    raycast
    tableplus
    vlc-bin
    yaak
    zoom-us
  ];
}
