{
  pkgs,
  neovim-nightly-overlay,
  ...
}:
let
  getConfig = filename: ./configuration-files/${filename};
  getDest = filename: "./.config/${filename}";
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.christopher = {
    imports = [
      ./aerospace.nix
      ./jankyborders.nix
      ./packages.nix
      ./tmux.nix
      ./zsh.nix
    ];
    home.username = "christopher";
    home.stateVersion = "25.05";
  };
  home-manager.extraSpecialArgs = {
    inherit neovim-nightly-overlay getConfig getDest;
  };
}
