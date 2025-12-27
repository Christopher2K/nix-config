{
  inputs,
  config,
  username,
  pkgs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = {
    imports = [
      ./modules/code
      ./modules/terminal
      ./modules/tools
      ./modules/packages
      ./modules/window-manager
    ];
    # ++ lib.optionals pkgs.stdenv.isDarwin [
    #   ./modules/wm.macos.nix
    # ]
    # ++ lib.optionals pkgs.stdenv.isLinux [
    #   inputs.hyprdynamicmonitors.homeManagerModules.default
    #   inputs.ags.homeManagerModules.default
    #   ./modules/wm.linux.nix
    # ];
    home.username = username;
    home.stateVersion = "25.11";
  };

  home-manager.extraSpecialArgs = rec {
    inherit inputs pkgs;

    src = filename_or_dirname: ./../files/${filename_or_dirname};
    homeDest = filename_or_dirname: "${config.users.users."${username}".home}/${filename_or_dirname}";
    configDest = filename_or_dirname: homeDest "/.config/${filename_or_dirname}";
  };
}
