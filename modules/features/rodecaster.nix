{
  config,
  lib,
  ...
}:
let
  rodecaster-pipewire-setup =
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
            lib.makeBinPath [
              pkgs.curl
              pkgs.gnused
              pkgs.pipewire
              pkgs.systemd
              pkgs.usbutils
            ]
          }

        runHook postInstall
      '';
    };
in
{
  flake.modules.nixos.rodecaster =
    { config, pkgs, ... }:
    let
      setup = rodecaster-pipewire-setup pkgs;
      setupScript = pkgs.writeShellScript "rodecaster-pipewire-setup-wrapper" ''
        ${setup}/bin/rodecaster-pipewire-setup --install --user || true
      '';
    in
    {
      # Rename the raw physical nodes so the main and chat devices are easy to
      # tell apart in pavucontrol / audio pickers.
      services.pipewire.wireplumber.extraConfig."zz-rodecaster-labels" = {
        "monitor.alsa.rules" = [
          # RODECaster Duo outputs
          {
            matches = [ { "node.name" = "~alsa_output\\.usb-R__DE_RODECaster_Duo_.*\\.pro-output-0"; } ];
            actions = {
              update-props = {
                "node.description" = "RODECaster Duo Chat Output";
                "node.nick" = "RODECaster Duo Chat Output";
              };
            };
          }
          {
            matches = [ { "node.name" = "~alsa_output\\.usb-R__DE_RODECaster_Duo_.*\\.pro-output-1"; } ];
            actions = {
              update-props = {
                "node.description" = "RODECaster Duo Main Output";
                "node.nick" = "RODECaster Duo Main Output";
              };
            };
          }
          # RODECaster Duo inputs
          {
            matches = [ { "node.name" = "~alsa_input\\.usb-R__DE_RODECaster_Duo_.*\\.pro-input-0"; } ];
            actions = {
              update-props = {
                "node.description" = "RODECaster Duo Chat Input";
                "node.nick" = "RODECaster Duo Chat Input";
              };
            };
          }
          {
            matches = [ { "node.name" = "~alsa_input\\.usb-R__DE_RODECaster_Duo_.*\\.pro-input-1"; } ];
            actions = {
              update-props = {
                "node.description" = "RODECaster Duo Main Input";
                "node.nick" = "RODECaster Duo Main Input";
              };
            };
          }
          # RODECaster Pro II outputs
          {
            matches = [ { "node.name" = "~alsa_output\\.usb-R__DE_RODECaster_Pro_II_.*\\.pro-output-0"; } ];
            actions = {
              update-props = {
                "node.description" = "RODECaster Pro II Chat Output";
                "node.nick" = "RODECaster Pro II Chat Output";
              };
            };
          }
          {
            matches = [ { "node.name" = "~alsa_output\\.usb-R__DE_RODECaster_Pro_II_.*\\.pro-output-1"; } ];
            actions = {
              update-props = {
                "node.description" = "RODECaster Pro II Main Output";
                "node.nick" = "RODECaster Pro II Main Output";
              };
            };
          }
          # RODECaster Pro II inputs
          {
            matches = [ { "node.name" = "~alsa_input\\.usb-R__DE_RODECaster_Pro_II_.*\\.pro-input-0"; } ];
            actions = {
              update-props = {
                "node.description" = "RODECaster Pro II Chat Input";
                "node.nick" = "RODECaster Pro II Chat Input";
              };
            };
          }
          {
            matches = [ { "node.name" = "~alsa_input\\.usb-R__DE_RODECaster_Pro_II_.*\\.pro-input-1"; } ];
            actions = {
              update-props = {
                "node.description" = "RODECaster Pro II Main Input";
                "node.nick" = "RODECaster Pro II Main Input";
              };
            };
          }
        ];
      };

      # Force the pro-audio profile on any connected RODECaster Pro II or Duo
      # so that the multichannel ALSA devices are exposed before the per-device
      # virtual channel config is generated.
      services.pipewire.wireplumber.extraConfig."10-rodecaster-pro-audio" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "device.vendor.id" = "0x19f7"; }
              { "device.product.id" = "0x0072"; }
            ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
              };
            };
          }
          {
            matches = [
              { "device.vendor.id" = "0x19f7"; }
              { "device.product.id" = "0x0094"; }
            ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
              };
            };
          }
          {
            matches = [
              { "device.vendor.id" = "0x19f7"; }
              { "device.product.id" = "0x0095"; }
            ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
              };
            };
          }
        ];
      };

      environment.systemPackages = [ setup ];

      # Run the virtual-device installer once per graphical login.  If a
      # RODECaster is connected it will create per-serial PipeWire loopbacks in
      # ~/.config/pipewire/pipewire.conf.d; otherwise it exits cleanly.
      systemd.user.services.rodecaster-pipewire-setup = {
        description = "Set up PipeWire virtual devices for RODECaster";
        after = [ "pipewire.service" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = setupScript;
          RemainAfterExit = true;
        };
      };
    };

  flake.modules.homeManager.rodecaster =
    { pkgs, ... }:
    {
      home.packages = [ (rodecaster-pipewire-setup pkgs) ];
    };
}
