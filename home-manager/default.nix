{
  inputs,
  config,
  username,
  hostname,
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
      ../hosts/${hostname}/home.nix
    ];
    home.username = username;
  };

  home-manager.extraSpecialArgs = rec {
    inherit
      inputs
      pkgs
      razerKeyboardSerial
      hostname
      ;

    src = filename_or_dirname: ./../files/${filename_or_dirname};
    homeDest = filename_or_dirname: "${config.users.users."${username}".home}/${filename_or_dirname}";
    configDest = filename_or_dirname: homeDest "/.config/${filename_or_dirname}";
  };
}
