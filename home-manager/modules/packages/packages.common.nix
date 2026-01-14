{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # CLI
    bat
    beamMinimal28Packages.rebar3
    claude-code
    codex
    devenv
    exercism
    fd
    fzf
    glow
    lazydocker
    lazygit
    neofetch
    nixfmt-rfc-style
    opencode
    ripgrep
    scrcpy
    tree-sitter
    watchman
    yazi

    # GUI
    yaak
    zoom-us
  ];
}
