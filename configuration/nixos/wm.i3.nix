{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.picom.enable = true;
  programs.i3lock.enable = true;
  services.displayManager.defaultSession = "none+i3";
  services.xserver.dpi = 120;
  services.xserver.windowManager.i3 = {
    enable = true;
  };
}
