{ configDest, src, ... }:
{
  home.file."${configDest "wallpapers"}" = {
    source = src "wallpapers";
    recursive = true;
  };

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      preload = [
        "~/.config/wallpapers/wallpaper-1.jpg"
        "~/.config/wallpapers/wallpaper-2.jpg"
      ];
      wallpaper = [
        ",~/.config/wallpapers/wallpaper-1.jpg"
      ];
    };
  };
}
