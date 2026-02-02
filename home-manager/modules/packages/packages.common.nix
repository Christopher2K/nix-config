{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # CLI
    awscli2
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
    nixfmt
    opencode
    ripgrep
    scrcpy
    texliveMedium
    tree-sitter
    watchman
    yazi

    # GUI
    yaak
    zoom-us
  ];
}
