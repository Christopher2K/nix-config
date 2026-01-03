{
  description = "Christopher's systems configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    niri.url = "github:sodiboo/niri-flake/97876f35dcd5";
    vicinae.url = "github:vicinaehq/vicinae";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qml-niri = {
      url = "github:imiric/qml-niri/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
  };

  outputs =
    { ... }@inputs:
    let
      username = "christopher";
      razerKeyboardSerial = "BY2516N73300445";
      commonSpecialArgs = {
        inherit
          inputs
          username
          razerKeyboardSerial
          ;
      };
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
          inputs.home-manager.nixosModules.home-manager
          ./configuration/nixos/configuration.nix
          ./home-manager
        ];
      };
    };
}
