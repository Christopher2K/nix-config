{
  config,
  configDest,
  src,
  ...
}:
{
  home.file."${configDest "wallpapers"}" = {
    source = src "wallpapers";
    recursive = true;
  };

  services.wpaperd = {
    enable = true;
    settings = {
      any = {
        path = configDest "wallpapers/wallpaper-1.jpg";
      };
    };
  };
}
