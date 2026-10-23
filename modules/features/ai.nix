{
  config,
  inputs,
  ...
}:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.homeManager.ai = helpers.mkHybrid {
    common =
      { pkgs, config, ... }:
      {
        home.packages = [
          inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode
          pkgs.codex
          pkgs.claude-code
        ];

        home.file.".config/opencode" = {
          source = helpers.mkAssetsPath "/opencode";
          force = true;
          recursive = true;
        };

        # Global agent skills (~/.agents/skills). Out-of-store symlink so
        # `npx skills add ... -g` can install into it without a rebuild.
        home.file.".agents/skills".source = config.lib.file.mkOutOfStoreSymlink (
          helpers.mkAssetsStringPath config "/global-ai-skills"
        );
      };

    # Linux opencode.json is linked by the pen module (pen.nix), which injects
    # the pencil MCP server path at build time.
    darwin =
      { ... }:
      {
        home.file.".config/opencode/opencode.json".source =
          helpers.mkAssetsPath "/opencode-config/opencode.darwin.json";
      };
  };
}
