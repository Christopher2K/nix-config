{
  inputs,
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
    exercism
    fastfetch
    fd
    fzf
    gh
    glow
    inputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.default
    lazydocker
    lazygit
    nixfmt
    inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode
    proton-pass-cli
    ripgrep
    scrcpy
    texliveMedium
    tree-sitter
    watchman
    yazi

    # GUI
    inputs.sqlit.packages.${pkgs.stdenv.hostPlatform.system}.default
    proton-pass
    yaak
    zoom-us
  ];
}
