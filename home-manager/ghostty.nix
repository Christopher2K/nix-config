{
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings = {
      theme = "Gruvbox Light";
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 16;
      macos-titlebar-style = "hidden";
      window-padding-x = 12;
      window-padding-y = 12;
      working-directory = "home";
      window-inherit-working-directory = false;
      window-save-state = "never";
    };
  };
}
