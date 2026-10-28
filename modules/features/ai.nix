{
  config,
  inputs,
  ...
}:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.darwin.ai = {
    homebrew.casks = [
    ];
  };

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

    linux =
      { ... }:
      {
        home.file.".config/opencode/opencode.json".source =
          helpers.mkAssetsPath "/opencode-config/opencode.linux.json";

        # Shared providers/models (e.g. omniroute). opencode deep-merges
        # opencode.jsonc into opencode.json, so platform-specific config lives
        # in opencode.json while shared providers live here.
        home.file.".config/opencode/opencode.jsonc".source =
          helpers.mkAssetsPath "/opencode-config/opencode.shared.json";
      };

    darwin =
      { ... }:
      {
        home.file.".config/opencode/opencode.json".source =
          helpers.mkAssetsPath "/opencode-config/opencode.darwin.json";

        # See linux block above.
        home.file.".config/opencode/opencode.jsonc".source =
          helpers.mkAssetsPath "/opencode-config/opencode.shared.json";
      };
  };
}
