{
  description = "Christopher's macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      homebrew-cask,
      homebrew-core,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      neovim-nightly-overlay,
      ...
    }:
    {
      darwinConfigurations."Christophers-MacBook" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit neovim-nightly-overlay homebrew-core homebrew-cask; };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          # home-manager.darwinModules.home-manager
          ./configuration.nix
        ];
      };
    };
}
