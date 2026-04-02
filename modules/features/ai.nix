{
  inputs,
  ...
}:
let
  # Upstream opencode has a stale npmDepsHash for x86_64-linux.
  # Override the node_modules hash until the next upstream release fixes it.
  opencodeOverlay =
    final: prev:
    let
      base = inputs.opencode.overlays.default final prev;
      correctedNodeModules = base.opencode.node_modules.override {
        hash = "sha256-I/I7YGrZPmnIPSh/BzvgAfQOMn90Jh3aFABVMqUn+Xw=";
      };
    in
    {
      opencode = base.opencode.override { node_modules = correctedNodeModules; };
    };
in
{
  flake.modules.nixos.ai = {
    nixpkgs.overlays = [
      opencodeOverlay
    ];
  };

  flake.modules.darwin.ai = flake.modules.nixos.ai;

  flake.modules.homeManager.ai =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        opencode
        codex
        claude-code
      ];

      home.file."${config.home.homeDirectory}/.config/opencode" = {
        source = ../../assets/opencode;
        force = true;
        recursive = true;
      };
    };
}
