pkgs:
pkgs.stdenvNoCC.mkDerivation {
  pname = "rodecaster-pipewire-setup";
  version = "0-unstable-2026-10-13";

  src = pkgs.fetchFromGitHub {
    owner = "parzival-space";
    repo = "rodecaster-pro-2-virtual-devices-pipewire";
    rev = "f253acc15088512bf72bb0f2c37e0758ca12c042";
    sha256 = "1id8j0hiql3v2vrqldgb827817d5p8qva5zvqyvpsa0cnd9hxcj7";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/rodecaster-pipewire
    cp configure.sh $out/bin/rodecaster-pipewire-setup
    cp *.template.conf $out/share/rodecaster-pipewire/

    substituteInPlace $out/bin/rodecaster-pipewire-setup \
      --replace-fail 'PIPEWIRE_CONFIG_DIR_SYSTEM="/usr/share/pipewire/pipewire.conf.d"' \
                     'PIPEWIRE_CONFIG_DIR_SYSTEM="/etc/pipewire/pipewire.conf.d"'

    sed -i "s|TEMPLATE_DOWNLOAD_URL_BASE=\"https://parzival-space\.github\.io/rodecaster-pro-2-virtual-devices-pipewire/\"|TEMPLATE_DOWNLOAD_URL_BASE=\"file://$out/share/rodecaster-pipewire/\"|" $out/bin/rodecaster-pipewire-setup

    wrapProgram $out/bin/rodecaster-pipewire-setup \
      --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.curl
          pkgs.gnused
          pkgs.pipewire
          pkgs.systemd
          pkgs.usbutils
        ]
      }

    runHook postInstall
  '';
}
