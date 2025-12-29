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
      ./niri.nix
      ./vicinae.nix
      ./waybar.nix
      ./kanshi.nix
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ./aerospace.nix
      ./jankyborders.nix
    ];
}
