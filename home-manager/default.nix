{
  pkgs,
  inputs,
  config,
  username,
  lib,
  mkHelpers,
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
    ];
    home.username = username;
    home.stateVersion = "25.11";
  };

  home-manager.extraSpecialArgs = rec {
    inherit inputs mkHelpers;
    getConfig = filename_or_dirname: ./configuration-files/${filename_or_dirname};

    src = filename_or_dirname: ./../files/${filename_or_dirname};
    homeDest = filename_or_dirname: "${config.users.users."${username}".home}/${filename_or_dirname}";
    configDest = filename_or_dirname: homeDest "/.config/${filename_or_dirname}";
  };
}
