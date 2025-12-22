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
      ./direnv.nix
      ./ghostty.nix
      ./git.nix
      ./glow.nix
      ./lf.nix
      ./mise.nix
      ./neovim.nix
      ./opencode.nix
      ./packages.nix
      ./tmux.nix
      ./zsh.nix
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ./aerospace.nix
      ./jankyborders.nix
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      ./hyprland.nix
      ./rofi.nix
    ];
    home.username = "christopher";
    home.stateVersion = "25.11";
  };

  home-manager.extraSpecialArgs = {
    inherit neovim-nightly-overlay;
    getConfig = filename: ./configuration-files/${filename};
    getDest = filename: "${config.users.users."${username}".home}/${filename}";
  };
}
