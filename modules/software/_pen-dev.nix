pkgs:
let
  pname = "pen-dev";
  version = "1.2.24";
  src = pkgs.fetchurl {
    url = "https://pen.dev/download/Pen-linux-x86_64.AppImage";
    hash = "sha256-NQ73bg62hxuFCAu+8/rlfUX6z26sCC4dPbECFjXFEMw=";
  };
  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    ln -s ${appimageContents}/resources/app.asar.unpacked/out/mcp-server-linux-x64 \
      $out/bin/pen-dev-mcp
    install -Dm644 ${appimageContents}/pen.desktop $out/share/applications/pen.desktop
    substituteInPlace $out/share/applications/pen.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=pen-dev'
    install -Dm644 ${appimageContents}/pen.png $out/share/icons/hicolor/512x512/apps/pen.png
  '';
}
