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
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal.url = "github:aylur/astal";
    ags.url = "github:aylur/ags";
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

      mkDarwin =
        hostname:
        inputs.nix-darwin.lib.darwinSystem {
          specialArgs = commonSpecialArgs // {
            inherit hostname;
          };
          modules = [
            inputs.nix-homebrew.darwinModules.nix-homebrew
            inputs.home-manager.darwinModules.home-manager
            ./modules/common.nix
            ./modules/darwin/common.nix
            ./hosts/${hostname}
            ./home-manager
          ];
        };

      mkNixos =
        hostname:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = commonSpecialArgs // {
            inherit hostname;
          };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            ./modules/common.nix
            ./modules/nixos/common.nix
            ./hosts/${hostname}
            ./home-manager
          ];
        };
    in
    {
      darwinConfigurations = {
        "Christophers-MacBook" = mkDarwin "macbook-personal";
        "CookUnityLaptop" = mkDarwin "macbook-work";
      };
      nixosConfigurations = {
        "razer-nix" = mkNixos "laptop";
      };
    };
}
