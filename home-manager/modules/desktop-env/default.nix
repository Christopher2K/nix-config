{
  pkgs,
  lib,
  ...
}:
{
  imports =
    [ ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      ./gtk.nix
      ./kanshi.nix
      ./niri.nix
      ./quickshell.nix
      ./stylix.nix
      ./vicinae.nix
      ./waybar.nix
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ./aerospace.nix
      ./jankyborders.nix
    ];
}
