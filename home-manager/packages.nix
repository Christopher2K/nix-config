{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Dependencies
    libyaml

    # CLI
    bat
    fd
    fzf
    lazydocker
    lazygit
    lf
    neofetch
    nixfmt-rfc-style
    opencode
    ripgrep
    scrcpy
    watchman
    xcodes

    # GUI
    orbstack
    raycast
    tableplus
    vlc-bin
    yaak
    zoom-us
  ];
}
