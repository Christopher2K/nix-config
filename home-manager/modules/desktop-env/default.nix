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
    ./gtk.nix
    ./kanshi.nix
    ./niri.nix
    ./quickshell.nix
    ./stylix.linux.nix
    ./vicinae.nix
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    ./aerospace.nix
    ./jankyborders.nix
    ./paneru.nix
  ];
}
