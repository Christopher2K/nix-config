{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than +10";
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  environment.systemPackages = with pkgs; [
    bc
  ];
}
