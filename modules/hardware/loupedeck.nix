{
  config,
  ...
}:
let
  username = config.flake.username;
  loupixdeck =
    pkgs:
    let
      runtimeLibs = [
        pkgs.fontconfig
        pkgs.freetype
        pkgs.libICE
        pkgs.libSM
        pkgs.libX11
        pkgs.libXcursor
        pkgs.libXext
        pkgs.libXi
        pkgs.libXinerama
        pkgs.libXrandr
        pkgs.libxkbcommon
        pkgs.icu
        pkgs.stdenv.cc.cc.lib
      ];
    in
    pkgs.stdenv.mkDerivation rec {
      pname = "loupixdeck";
      version = "1.63.0";

      src = pkgs.fetchurl {
        url = "https://github.com/RadiatorTwo/LoupixDeck/releases/download/v${version}/LoupixDeck-linux-x64.tar.gz";
        hash = "sha256-OxrVl8ZJhdWY5AoQ2tm2x1kAgiqvilyAJ5gtUAfuHno=";
      };

      # Patching or stripping the self-contained .NET single-file executable
      # corrupts its embedded bundle. The wrapper supplies its libraries and
      # nix-ld supplies the ELF interpreter instead.
      nativeBuildInputs = [ pkgs.makeWrapper ];

      sourceRoot = ".";
      dontConfigure = true;
      dontBuild = true;
      dontStrip = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/loupixdeck $out/bin
        cp -r . $out/lib/loupixdeck/

        makeWrapper $out/lib/loupixdeck/LoupixDeck $out/bin/loupixdeck \
          --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath runtimeLibs} \
          --prefix PATH : ${
            pkgs.lib.makeBinPath [
              pkgs.ffmpeg
              pkgs.xprop
            ]
          }

        install -Dm644 LoupixDeck.png $out/share/icons/hicolor/512x512/apps/loupixdeck.png
        mkdir -p $out/share/applications
        cat > $out/share/applications/loupixdeck.desktop <<EOF
        [Desktop Entry]
        Name=LoupixDeck
        Comment=Control Loupedeck and Razer Stream Controller devices
        Exec=$out/bin/loupixdeck
        Icon=loupixdeck
        Terminal=false
        Type=Application
        Categories=Utility;AudioVideo;
        StartupNotify=true
        EOF

        runHook postInstall
      '';

      meta = {
        description = "Open-source control deck software for Loupedeck and Razer Stream Controller devices";
        homepage = "https://github.com/RadiatorTwo/LoupixDeck";
        license = pkgs.lib.licenses.mit;
        platforms = [ "x86_64-linux" ];
        sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
        mainProgram = "loupixdeck";
      };
    };
in
{
  flake.modules.nixos.loupedeck = { config, pkgs, ... }: {
    environment.systemPackages = [ (loupixdeck pkgs) ];

    programs.nix-ld.enable = true;
    hardware.uinput.enable = true;
    users.users.${username}.extraGroups = [
      "input"
      "uinput"
    ];

    # Device permissions from the upstream Linux installer. The uinput
    # portion is handled by hardware.uinput.enable above.
    services.udev.extraRules = ''
      # Loupedeck Live (2ec2:0004)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2ec2", ATTRS{idProduct}=="0004", MODE="0666"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2ec2", ATTRS{idProduct}=="0004", MODE="0666"
      # Loupedeck Live S (2ec2:0006)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2ec2", ATTRS{idProduct}=="0006", MODE="0666"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2ec2", ATTRS{idProduct}=="0006", MODE="0666"
      # Loupedeck CT (2ec2:0003 and 2ec2:0007)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2ec2", ATTRS{idProduct}=="0003", MODE="0666"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2ec2", ATTRS{idProduct}=="0003", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2ec2", ATTRS{idProduct}=="0007", MODE="0666"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2ec2", ATTRS{idProduct}=="0007", MODE="0666"
      # Razer Stream Controller (1532:0d06)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0d06", MODE="0666"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0d06", MODE="0666"
      # Razer Stream Controller X (1532:0d09)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0d09", MODE="0666"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0d09", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0d09", MODE="0666"
    '';
  };
}
