{
  inputs,
  ...
}:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        opencode
        codex
        claude-code
      ];

      home.file.".config/opencode" = {
        source = ../../assets/opencode;
        force = true;
        recursive = true;
      };
    };
}
