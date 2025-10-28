{
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      "vim" = "nvim";
      "switch" = "sudo darwin-rebuild switch";
    };
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "sudo"
    ];
  };

  programs.starship = {
    enable = true;
  };
}
