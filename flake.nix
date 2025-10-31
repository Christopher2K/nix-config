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
      homebrew-cask,
      homebrew-core,
      neovim-nightly-overlay,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      darwinConfiguration = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit neovim-nightly-overlay homebrew-core homebrew-cask;
          username = "christopher";
        };

        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          ./configuration
          ./home-manager
        ];
      };
    in
    {
      darwinConfigurations."Christophers-MacBook" = darwinConfiguration;
      darwinConfigurations."CookUnityLaptop" = darwinConfiguration;
    };
}
