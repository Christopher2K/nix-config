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
      { pkgs, ... }:
      let
        system = pkgs.stdenv.hostPlatform.system;
        opencodePkg = inputs.opencode.packages.${system}.opencode;
        # v2.0.21 shipped a stale node_modules FOD hash for aarch64-darwin
        # (anomalyco/opencode nix/hashes.json); override with the correct one.
        fixedNodeModules = opencodePkg.node_modules.overrideAttrs (_: {
          outputHash = "sha256-1Q+c4Ww1KoL7s60j9boEZkhKWYQJRxTRoPIFqOKJEeM=";
        });
        opencode =
          if system == "aarch64-darwin" then
            # ...and its postInstall `opencode completion` invocation chdirs into a
            # nonexistent directory; skip shell completion generation for now.
            (opencodePkg.override { node_modules = fixedNodeModules; }).overrideAttrs (_: {
              postInstall = "";
            })
          else
            opencodePkg;
      in
      {
        home.packages = [
          opencode
          pkgs.codex
          pkgs.claude-code
        ];

        home.file.".config/opencode" = {
          source = helpers.mkAssetsPath "/opencode";
          force = true;
          recursive = true;
        };
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
