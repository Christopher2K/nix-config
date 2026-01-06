{
  inputs,
  config,
  username,
  razerKeyboardSerial,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    inputs.nur.overlays.default
    inputs.neovim-nightly-overlay.overlays.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = {
    imports = [
      inputs.niri.homeModules.niri
      inputs.niri.homeModules.stylix
      inputs.stylix.homeModules.stylix
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
    inherit inputs pkgs razerKeyboardSerial;

    src = filename_or_dirname: ./../files/${filename_or_dirname};
    homeDest = filename_or_dirname: "${config.users.users."${username}".home}/${filename_or_dirname}";
    configDest = filename_or_dirname: homeDest "/.config/${filename_or_dirname}";
  };
}
