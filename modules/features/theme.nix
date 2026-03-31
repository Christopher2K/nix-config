{
  inputs,
  ...
}:
{
  flake.modules.homeManager.theme =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.stylix.homeModules.stylix
      ];

      home.packages = with pkgs; [
        base16-schemes
      ];

      stylix = {
        enable = true;
        autoEnable = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light.yaml";

        # image = ../../../files/wallpapers/wallpaper-1.jpg;
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
            terminal = 12;
            desktop = 12;
            applications = 12;
          };
        };
      };

      # Common stylix targets
      stylix.targets.ghostty = {
        enable = true;
      };
      stylix.targets.fontconfig.enable = true;
      stylix.targets.starship.enable = true;
      stylix.targets.vencord.enable = true;
      stylix.targets.vesktop.enable = true;
      stylix.targets.gnome.enable = true;
      stylix.targets.gtk.enable = true;
      stylix.targets.qt.enable = true;
      stylix.targets.vicinae.enable = true;
      stylix.targets.noctalia-shell.enable = true;

      # Use the KDE platform theme so Qt apps pick up Stylix colours and
      # integrate with the rest of the desktop (cursors, fonts, dialogs).
      # mkForce is required because stylix sets platformTheme.name = "qtct" by default.
      qt = {
        enable = true;
        platformTheme.name = lib.mkForce "kde";
        style.name = "breeze";
      };
    };
}
