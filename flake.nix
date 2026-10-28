{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-barutsrb-tap = {
      url = "github:BarutSRB/homebrew-tap";
      flake = false;
    };

    homebrew-tinycast-tap = {
      url = "github:abue-ammar/homebrew-tinycast";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    tree-sitter.url = "github:tree-sitter/tree-sitter";
    tree-sitter.inputs.nixpkgs.follows = "nixpkgs";

    opencode.url = "github:anomalyco/opencode/v2.1.4";
    opencode.inputs.nixpkgs.follows = "nixpkgs";

    # Helium browser for NixOS (darwin gets it via homebrew cask).
    helium.url = "github:amaanq/helium-flake";
    helium.inputs.nixpkgs.follows = "nixpkgs";

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    sqlit.url = "github:maxteabag/sqlit";
    sqlit.inputs.nixpkgs.follows = "nixpkgs";

    dms.url = "github:AvengeMedia/DankMaterialShell/stable";
    dms.inputs.nixpkgs.follows = "nixpkgs";
    dms-plugin-registry.url = "github:AvengeMedia/dms-plugin-registry";
    dgop.url = "github:AvengeMedia/dgop";
    dgop.inputs.nixpkgs.follows = "nixpkgs";
    matugen.url = "github:/InioX/Matugen";
    matugen.inputs.nixpkgs.follows = "nixpkgs";

    proton-cachyos.url = "github:powerofthe69/proton-cachyos-nix";
    proton-cachyos.inputs.nixpkgs.follows = "nixpkgs";

    # Pinned to a release tag; upstream CI builds each tag into its Cachix cache.
    # No nixpkgs follows: the cache holds builds against the flake's locked nixpkgs.
    proton-drive-linux.url = "github:narrrl/proton-drive-linux/v3.5.0";

    herdr.url = "github:ogulcancelik/herdr";
    herdr.inputs.nixpkgs.follows = "nixpkgs";

    # Local checkout until the flake PR lands upstream; then switch to
    # github:jonesy827/pippin
    pippin.url = "path:/home/christopher/Developer/pippin";
    pippin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
