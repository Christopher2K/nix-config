{ config, ... }:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.homeManager.limusic = helpers.mkHybrid {
    linux =
      { pkgs, ... }:
      let
        # Official AppImage wrapped in an FHS env so it finds system libs
        # (libgpg-error, webkitgtk deps, etc.). Update version + hash together:
        #   nix hash convert --hash-algo sha256 --to sri $(nix hash file --type sha256 --base32 limusic_<ver>_amd64.AppImage)
        limusic-src = pkgs.fetchurl {
          url = "https://github.com/SimoHypers/limusic/releases/download/v1.3.0/limusic_1.3.0_amd64.AppImage";
          hash = "sha256-skhW7OeTMN06Y/WvI5Tm+Dja50rtxh42d0Q96Qwrc4c=";
        };

        limusic = pkgs.appimageTools.wrapType2 {
          pname = "limusic";
          version = "1.3.0";

          src = limusic-src;

          extraPkgs = pkgs: with pkgs; [
            libgpg-error
            libsecret
            webkitgtk_4_1
            gtk3
            glib-networking
          ];

          meta = {
            description = "Feature rich, native desktop, YouTube Music client";
            homepage = "https://github.com/SimoHypers/limusic";
            license = pkgs.lib.licenses.gpl3Only;
            platforms = [ "x86_64-linux" ];
            mainProgram = "limusic";
          };
        };

        # wrapType2 installs no .desktop entry or icons; pull them out of the
        # AppImage so launchers can find Limusic. Exec points at the wrapper.
        limusic-desktop = pkgs.runCommand "limusic-desktop" { } ''
          extracted=${pkgs.appimageTools.extractType2 {
            pname = "limusic";
            version = "1.3.0";
            src = limusic-src;
          }}
          mkdir -p $out/share/applications $out/share/icons/hicolor/512x512/apps
          substitute $extracted/limusic.desktop $out/share/applications/limusic.desktop \
            --replace-fail "Exec=limusic-app" "Exec=limusic"
          install -Dm644 $extracted/limusic-app.png \
            $out/share/icons/hicolor/512x512/apps/limusic-app.png
        '';
      in
      {
        home.packages = [
          limusic
          limusic-desktop
        ];
      };
  };
}
