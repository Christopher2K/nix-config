{
  pkgs,
  neovim-nightly-overlay,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.christopher = {
    imports = [
      ./packages.nix
      ./dotfiles.nix
    ];
    home.username = "christopher";
    home.stateVersion = "25.05";
  };
  home-manager.extraSpecialArgs = {
    inherit neovim-nightly-overlay;
  };
}
