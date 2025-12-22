{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];

  programs.zsh.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    gnupg
    pkg-config
    cmake
    lshw
    pciutils
    unzip
  ];
}
