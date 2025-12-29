{
  inputs,
  config,
  username,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = {
    imports = [
      inputs.niri.homeModules.niri
      ./modules/code
      ./modules/terminal
      ./modules/tools
      ./modules/packages
      ./modules/desktop-env
    ];
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
