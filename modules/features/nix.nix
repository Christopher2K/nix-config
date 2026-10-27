{
  lib,
  ...
}:
let
  # Binary caches for flake inputs that publish prebuilt artifacts.
  # Keys verified against the Cachix API (https://app.cachix.org/api/v1/cache/<name>).
  # cache.nixos.org must stay listed so the official cache keeps working.
  substituters = [
    "https://cache.nixos.org"
    "https://niri.cachix.org"
    "https://nix-community.cachix.org"
    "https://devenv.cachix.org"
    "https://stylix.cachix.org"
    "https://vicinae.cachix.org"
    "https://opencode.cachix.org"
  ];

  trustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "stylix.cachix.org-1:a7S1pDuApwLyUr8vz7feei3oTV2gtk0E6gXl30SAIAc="
    "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    "opencode.cachix.org-1:LdhuFTs/xrlYuchvsF+cOBCgCKEJIcesw9ef06GPlXU="
  ];

  cacheSettings = {
    nix.settings = {
      inherit substituters;
      trusted-public-keys = trustedPublicKeys;

      # Deduplicate identical files in the store.
      auto-optimise-store = true;
    };
  };
in
{
  flake.modules.nixos.nix = cacheSettings;
  flake.modules.darwin.nix = cacheSettings;
}
