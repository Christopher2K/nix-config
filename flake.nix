{
  description = "Christopher's systems configurations";

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
    hyprland.url = "github:hyprwm/hyprland";
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";
    astal.url = "github:aylur/astal";
    ags.url = "github:aylur/ags";
  };

  outputs =
    { ... }@inputs:
    let
      # Constants
      username = "christopher";
      commonModules = [
        ./home-manager

      ];

      # Special args
      commonSpecialArgs = {
        inherit
          inputs
          username
          ;
      };

      # Common configurations
      darwinConfiguration = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = commonSpecialArgs;
        modules = [
          inputs.nix-homebrew.darwinModules.nix-homebrew
          inputs.home-manager.darwinModules.home-manager
          ./configuration/macos/configuration.nix
          ./home-manager
        ];
      };
    in
    {
      darwinConfigurations."Christophers-MacBook" = darwinConfiguration;
      darwinConfigurations."CookUnityLaptop" = darwinConfiguration;
      nixosConfigurations."razer-nix" = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = commonSpecialArgs;
        modules = [
          inputs.hyprdynamicmonitors.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          ./configuration/nixos/configuration.nix
          ./home-manager
        ];
      };
    };
}
