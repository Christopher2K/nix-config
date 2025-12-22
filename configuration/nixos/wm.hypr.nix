{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) hyprland;
in {
  # https://wiki.hypr.land/Nvidia/#suspendwakeup-issues
  hardware.nvidia.powerManagement.enable = true;

  programs.hyprland = {
    enable = true;
    # Les dérivations de NixOS servent principalement à configurer le package et fournissent
    # généralement un `pacakge` qui nous permet de spécifier la version d'un package qu'on veut utiliser =)
    # Dans notre cas, on remplace hyprland du Nix repository par celui du flake Hyprland
    # cf: https://mynixos.com/nixpkgs/option/programs.hyprland.package
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Je te conseille de passer par home-manager plus tard pour ça (+ Stylix)
    hyprpaper
    kitty
  ];
}
