{
  pkgs,
  ...
}:
{
  gtk = {
    enable = true;
    theme.package = pkgs.gruvbox-gtk-theme;
    theme.name = "Gruvbox-Dark";
  };
}
