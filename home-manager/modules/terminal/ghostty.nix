{
  pkgs,
  ...
}:
{

  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    enableZshIntegration = true;
    settings = {
      theme = "Gruvbox Light";
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 14;
      macos-titlebar-style = "hidden";
      window-padding-x = 12;
      window-padding-y = 12;
      working-directory = "home";
      window-inherit-working-directory = false;
      window-save-state = "never";
    };
  };
}
