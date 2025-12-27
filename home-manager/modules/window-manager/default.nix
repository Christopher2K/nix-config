{
  pkgs,
  lib,
  ...
}:
{
  imports =
    [ ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      ./ags.nix
      ./gtk.nix
      ./hyprlauncher.nix
      ./hyprpaper.nix
      ./hyprdynamicmonitors.nix
      ./hyprland.nix
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ./aerospace.nix
      ./jankyborders.nix
    ];
}
