{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    nix-direnv.enable = true;
    mise.enable = true;

  };
}
