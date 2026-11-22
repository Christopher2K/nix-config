{
  flake.modules.nixos.design =
    { pkgs, ... }:
    let
      pname = "pen-dev";
      version = "1.2.24";
      src = pkgs.fetchurl {
        url = "https://pen.dev/download/Pen-linux-x86_64.AppImage";
        hash = "sha256-NQ73bg62hxuFCAu+8/rlfUX6z26sCC4dPbECFjXFEMw=";
      };
      appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
      pen-dev = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        extraInstallCommands = ''
          install -Dm644 ${appimageContents}/pen.desktop $out/share/applications/pen.desktop
          substituteInPlace $out/share/applications/pen.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=pen-dev'
          install -Dm644 ${appimageContents}/pen.png $out/share/icons/hicolor/512x512/apps/pen.png
        '';
      };
    in
    {
      environment.systemPackages = [ pen-dev ];
    };

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
