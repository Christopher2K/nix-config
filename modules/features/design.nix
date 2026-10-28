{
  flake.modules.nixos."3d-design" =
    {
      pkgs,
      ...
    }:
    {
      # Plasticity 26.2.0 segfaults on launch (renderer process, V8 stack overflow)
      # after its Electron 26 -> 42 bump. Pin to the last working version until fixed.
      nixpkgs.overlays = [
        (final: prev: {
          plasticity = prev.plasticity.overrideAttrs (old: rec {
            version = "26.1.4";
            src = final.fetchurl {
              url = "https://github.com/nkallen/plasticity/releases/download/v${version}/Plasticity-${version}-1.x86_64.rpm";
              hash = "sha256-paBF0lk8rvuY4lnl5v7nOXaFsZQuNkTtXCoW53xBiMU=";
            };
          });
        })
      ];

      environment.systemPackages = with pkgs; [
        plasticity
        bambu-studio
      ];
    };

  flake.modules.darwin.design = {
    homebrew.casks = [
      "figma"
      "cleanshot"
      "cap"
    ];
  };

  flake.modules.darwin."3d-design" = {
    homebrew.casks = [
      "bambu-studio"
      "bambu-connect"
    ];
  };
}
