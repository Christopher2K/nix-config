pkgs:
let
  pname = "openpencil";
  version = "0.17.0";
  src = pkgs.fetchurl {
    url = "https://github.com/open-pencil/open-pencil/releases/download/v${version}/OpenPencil_${version}_amd64.AppImage";
    # Verified against the release SHA256SUMS. Recompute on version bumps:
    #   nix hash convert --hash-algo sha256 --to sri $(nix hash file --type sha256 --base32 OpenPencil_<ver>_amd64.AppImage)
    hash = "sha256-Q9o9vXoiOhA2kt0tkZOob43cs9t1d703OUmq6EVelPw=";
  };
  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  # Tauri v2 app: the FHS env needs WebKitGTK 4.1 and the libs it drags in
  # (libgpg-error, libsecret, ...) or the bundled runtime fails to start.
  extraPkgs =
    pkgs: with pkgs; [
      libgpg-error
      libsecret
      webkitgtk_4_1
      gtk3
      glib-networking
    ];

  # wrapType2 installs no .desktop entry or icon; pull them from the AppImage
  # and point Exec at the generated wrapper (named after pname).
  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/OpenPencil.desktop $out/share/applications/OpenPencil.desktop
    substituteInPlace $out/share/applications/OpenPencil.desktop \
      --replace-fail 'Exec=OpenPencil %U' 'Exec=openpencil %U'
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/256x256@2/apps/OpenPencil.png \
      $out/share/icons/hicolor/256x256/apps/OpenPencil.png
  '';

  meta = {
    description = "Open-source design editor that opens Figma (.fig) and Pencil (.pen) files";
    homepage = "https://openpencil.dev";
    license = pkgs.lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "openpencil";
  };
}
