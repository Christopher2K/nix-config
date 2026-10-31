# Workstation: everything needed on the machines I connect to remotely to
# work on (nixstation, studio).
#
# T3 Code (t3): agent control surface — desktop app + `t3` CLI come from
# nixpkgs via the coding feature (installed on every machine); this module adds
# the sync of the secrets the T3 background service needs into service.env.
#
# The service reads KEY=VALUE entries from ~/.t3/service.env (see
# docs/user/background-service.md upstream). We mirror the subset of keys that
# T3-spawned agents need (MCP auth tokens, etc.) from the pass-cli rendered
# env cache (~/.cache/env/.env.cache) on every activation, so secrets never
# enter the Nix store. PATH is intentionally not mirrored: the service
# launcher builds its own PATH and ignores it anyway.
{
  ...
}:
let
  envKeys = [
    "GITHUB_TOKEN"
    "OMNIROUTE_MANAGEMENT_KEY"
    "COOLIFY_MANAGEMENT_KEY"
  ];
in
{
  flake.modules.homeManager.workstation =
    { pkgs, lib, ... }:
    {
      home.activation.t3ServiceEnv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        cacheFile="$HOME/.cache/env/.env.cache"
        targetFile="$HOME/.t3/service.env"

        if [ ! -f "$cacheFile" ]; then
          echo "t3code: $cacheFile missing; run secure-env-refresh, re-switch, then 't3 service restart'"
        else
          newFile=$(${pkgs.coreutils}/bin/mktemp)
          ${lib.concatMapStringsSep "\n" (key: ''
            ${pkgs.gnused}/bin/sed -n -E 's/^export ${key}=/${key}=/p' "$cacheFile" >> "$newFile"
          '') envKeys}

          if [ ! -f "$targetFile" ] || ! ${pkgs.diffutils}/bin/cmp -s "$newFile" "$targetFile"; then
            /bin/mkdir -p "$HOME/.t3"
            /usr/bin/install -m 600 "$newFile" "$targetFile"
            echo "t3code: $targetFile updated; run 't3 service restart' for it to take effect"
          fi
          ${pkgs.coreutils}/bin/rm -f "$newFile"
        fi
      '';
    };
}
