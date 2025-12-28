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
      size = 12;
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
