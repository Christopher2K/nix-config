{
  pkgs,
  configDest,
  src,
  ...
}:
{
  gtk = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
    };

    theme = {
      package = pkgs.gruvbox-gtk-theme;
      name = "Gruvbox-Light";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };
}
