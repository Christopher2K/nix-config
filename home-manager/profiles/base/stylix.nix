{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
  ];
  home.packages = with pkgs; [
    base16-schemes
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light.yaml";

    image = ../../../files/wallpapers/wallpaper-1.jpg;
    cursor = {
      size = 32;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = config.stylix.fonts.monospace;
      serif = config.stylix.fonts.monospace;
      emoji = {
        package = pkgs.whatsapp-emoji-font;
        name = "WhatsAppEmoji";
      };

      sizes = {
        terminal = 14;
        desktop = 12;
        applications = 12;
      };
    };
    opacity = {
      terminal = 0.9;
    };
  };

  # Common stylix targets
  stylix.targets.ghostty = {
    enable = true;
    opacity.enable = true;
  };
  stylix.targets.fontconfig.enable = true;
  stylix.targets.starship.enable = true;
}
