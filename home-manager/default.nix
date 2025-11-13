{
  pkgs,
  neovim-nightly-overlay,
  config,
  username,
  lib,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.christopher = {
    imports = [
      ./aerospace.nix
      ./ghostty.nix
      ./git.nix
      ./jankyborders.nix
      ./mise.nix
      ./neovim.nix
      ./opencode.nix
      ./packages.nix
      ./tmux.nix
      ./zsh.nix
    ];
    home.username = "christopher";
    home.stateVersion = "25.05";
  };
  home-manager.extraSpecialArgs = {
    inherit neovim-nightly-overlay;
    getConfig = filename: ./configuration-files/${filename};
    getDest = filename: "${config.users.users."${username}".home}/${filename}";
  };
}
