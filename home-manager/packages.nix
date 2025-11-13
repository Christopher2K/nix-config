{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # CLI
    bat
    claude-code
    codex
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
    tree-sitter
    watchman

    # GUI
    orbstack
    raycast
    tableplus
    vlc-bin
    yaak
    zoom-us
  ];
}
