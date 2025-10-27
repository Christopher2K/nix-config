{
  pkgs,
  neovim-nightly-overlay,
  ...
}:
let
  home-config = {
    home.username = "christopher";

    home.packages = with pkgs; [
      # CLI
      bat
      fd
      fzf
      jankyborders
      lazydocker
      lazygit
      lf
      neofetch
      opencode
      ripgrep
      scrcpy
      starship
      tmux
      watchman
      xcodes

      # GUI
      aerospace
      mise
      nixfmt-rfc-style
      orbstack
      raycast
      tableplus
      vlc-bin
      yaak
      zoom-us

      # Nightly stuff
      neovim-nightly-overlay.packages.${pkgs.system}.default
    ];

    home.stateVersion = "25.05";
  };
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.christopher = home-config;
}
