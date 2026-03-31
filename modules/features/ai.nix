{
  inputs,
  ...
}:
{
  flake.modules.nixos.ai = {
    nixpkgs.overlays = [
      inputs.opencode.overlays.default
    ];
  };

  flake.modules.darwin.ai = {
    nixpkgs.overlays = [
      inputs.opencode.overlays.default
    ];
  };

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
