# The Ankama Launcher auto-updater only works when running as a real
# AppImage: it needs $APPIMAGE to locate the file to replace. The nixpkgs
# package runs the extracted AppImage in an FHS env where that variable is
# unset, so as soon as upstream publishes a newer launcher the update task
# throws and the launcher dies at startup with a fatal error.
# Disable the updater by blanking its feed URL inside app.asar. The
# replacement must keep the exact same byte length: asar archives store
# files contiguously, so resizing main.js would corrupt the offsets.
final: prev: {
  ankama-launcher =
    let
      inherit (prev.ankama-launcher) pname version src;
      contents = prev.appimageTools.extract {
        inherit pname version src;
        postExtract = ''
          chmod +w $out/resources/app.asar
          old='autoupdaterUrl:"https://launcher.cdn.ankama.com/installers"'
          new='autoupdaterUrl:!1'
          pad=$(( ''${#old} - ''${#new} ))
          if [ "$pad" -lt 0 ]; then
            echo "ankama-launcher: updater patch target shrank, update the overlay" >&2
            exit 1
          fi
          new="$new$(printf "%''${pad}s" "")"
          if ! grep -aqF "$old" $out/resources/app.asar; then
            echo "ankama-launcher: updater feed URL not found in app.asar" >&2
            exit 1
          fi
          sed -i "s|autoupdaterUrl:\"https://launcher\.cdn\.ankama\.com/installers\"|$new|g" $out/resources/app.asar
        '';
      };
    in
    prev.appimageTools.wrapAppImage {
      inherit
        pname
        version
        src
        contents
        ;
      extraPkgs = pkgs: [ pkgs.wine ];
      extraInstallCommands = ''
        install -m 444 -D ${contents}/zaap.desktop $out/share/applications/ankama-launcher.desktop
        sed -i 's/.*Exec.*/Exec=ankama-launcher/' $out/share/applications/ankama-launcher.desktop
        install -m 444 -D ${contents}/zaap.png $out/share/icons/hicolor/256x256/apps/zaap.png
      '';
      inherit (prev.ankama-launcher) meta;
    };
}
