{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    cycle = true;
  };
}
