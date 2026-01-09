{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./stylix.common.nix
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    ./ags.nix
    ./gtk.nix
    ./kanshi.nix
    ./niri.nix
    ./qt.nix
    ./quickshell.nix
    ./stylix.linux.nix
    ./vicinae.nix
    ./xdg.nix
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    ./aerospace.nix
    ./jankyborders.nix
    ./paneru.nix
  ];
}
