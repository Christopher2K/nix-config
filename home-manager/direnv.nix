{
  pkgs,
  lib,
  ...
}:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
    mise.enable = true;
  };

  # Not working -- Says stuff like curl are missing
  # home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   ${pkgs.mise}/bin/mise install
  # '';
}
