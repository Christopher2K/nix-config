{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      base-profile = {
        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            onepassword-password-manager
            vimium
          ];
        };
      };
    };
  };
}
