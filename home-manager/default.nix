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
  home-manager.users.${username} = {
    imports = [
      ./modules/code.nix
      ./modules/terminal.nix
      ./modules/tools.nix
      ./modules/packages.nix
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ./modules/wm.macos.nix
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      ./modules/wm.linux.nix
    ];
    home.username = username;
    home.stateVersion = "25.11";
  };

  home-manager.extraSpecialArgs = rec {
    inherit inputs mkHelpers;

    src = filename_or_dirname: ./../files/${filename_or_dirname};
    homeDest = filename_or_dirname: "${config.users.users."${username}".home}/${filename_or_dirname}";
    configDest = filename_or_dirname: homeDest "/.config/${filename_or_dirname}";
  };
}
