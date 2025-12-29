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
