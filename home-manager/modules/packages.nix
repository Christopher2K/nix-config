{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
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
      lf
      neofetch
      nixfmt-rfc-style
      opencode
      ripgrep
      scrcpy
      tree-sitter
      watchman

      # GUI
      yaak
      zoom-us
    ]
    ++ lib.optionals stdenv.isDarwin [
      orbstack
      tableplus
      vlc-bin-universal
    ]
    ++ lib.optionals stdenv.isLinux [
      inputs.hyprdynamicmonitors.packages.${pkgs.stdenv.hostPlatform.system}.default
      jq

      # GUI
      vesktop
    ];
}
