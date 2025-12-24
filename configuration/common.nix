{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  environment.systemPackages = with pkgs; [ ];
}
