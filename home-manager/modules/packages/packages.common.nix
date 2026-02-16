{
  inputs,
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
    inputs.expert.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    inputs.sqlit.packages.${pkgs.stdenv.hostPlatform.system}.default
    yaak
    zoom-us
  ];
}
