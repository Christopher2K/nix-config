{
  pkgs,
  lib,
  ...
}:
{
  imports =
    [ ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      ./niri.nix
      ./gtk.nix
      ./waybar.nix
      # ./hyprdynamicmonitors.nix
      # ./hyprland.nix
      # ./hyprlauncher.nix
      # ./hyprpanel.nix
      # ./hyprpaper.nix
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ./aerospace.nix
      ./jankyborders.nix
    ];
}
