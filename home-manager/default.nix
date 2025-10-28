{
  pkgs,
  neovim-nightly-overlay,
  config,
  username,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.christopher = {
    imports = [
      ./aerospace.nix
      ./git.nix
      ./jankyborders.nix
      ./packages.nix
      ./neovim.nix
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
