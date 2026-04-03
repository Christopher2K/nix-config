{
  flake.modules.darwin.sound = {
    home.brews = [
      "loopback"
    ];
  };

  flake.modules.nixos.sound =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;

        # Use software volume to work around CS35L56 woofer amps not
        # responding to hardware volume changes (patched=0).
        # ASUS ROG Zephyrus G14 2024 (GA403W), SSID 10431024.
        wireplumber.configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-alsa-soft-mixer.conf" (
            builtins.toJSON {
              "monitor.alsa.rules" = [
                {
                  matches = [
                    { "device.name" = "alsa_card.pci-0000_65_00.6"; }
                  ];
                  actions.update-props = {
                    "api.alsa.soft-mixer" = true;
                  };
                }
              ];
            }
          ))
        ];
      };

      # Force pro-audio profile on both RODECaster Duo cards so that
      # WirePlumber creates all three stream pairs (main, chat, secondary).
      services.pipewire.wireplumber.extraConfig."52-rodecaster-profile" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "device.name" = "alsa_card.usb-R__DE_RODECaster_Duo_IR0008380-00"; }
              { "device.name" = "alsa_card.usb-R__DE_R__DECaster_Duo-00"; }
            ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
              };
            };
          }
        ];
      };

      # Rodecaster for wireplumber
      services.pipewire.wireplumber.extraConfig."53-rodecaster-rename" = {
        "monitor.alsa.rules" = [
          # Outputs
          {
            matches = [ { "node.name" = "alsa_output.usb-R__DE_R__DECaster_Duo-00.pro-output-0"; } ];
            actions = {
              update-props = {
                "node.description" = "Rodecaster Secondary Output";
              };
            };
          }
          {
            matches = [ { "node.name" = "alsa_output.usb-R__DE_RODECaster_Duo_IR0008380-00.pro-output-0"; } ];
            actions = {
              update-props = {
                "node.description" = "Rodecaster Chat Output";
              };
            };
          }
          {
            matches = [ { "node.name" = "alsa_output.usb-R__DE_RODECaster_Duo_IR0008380-00.pro-output-1"; } ];
            actions = {
              update-props = {
                "node.description" = "Rodecaster Main Output";
              };
            };
          }

          # Inputs
          {
            matches = [ { "node.name" = "alsa_input.usb-R__DE_R__DECaster_Duo-00.pro-input-0"; } ];
            actions = {
              update-props = {
                "node.description" = "Rodecaster Secondary Input";
              };
            };
          }
          {
            matches = [ { "node.name" = "alsa_input.usb-R__DE_RODECaster_Duo_IR0008380-00.pro-input-0"; } ];
            actions = {
              update-props = {
                "node.description" = "Rodecaster Chat Input";
              };
            };
          }
          {
            matches = [ { "node.name" = "alsa_input.usb-R__DE_RODECaster_Duo_IR0008380-00.pro-input-1"; } ];
            actions = {
              update-props = {
                "node.description" = "Rodecaster Main Input";
              };
            };
          }
        ];
      };

      # WirePlumber restores saved ALSA state on boot/resume that soft-mixer
      # won't override. Pin hardware mixer to nominal levels.
      # Must be a user service: pipewire/wireplumber run in the user session.
      # after = wireplumber.service ensures we run after WirePlumber has
      # finished restoring its own state, eliminating the old sleep 2 race.
      systemd.user.services.fix-cs35l56-mixer = {
        description = "Pin ALSA hardware mixer for CS35L56 soft-mixer";
        after = [
          "pipewire.service"
          "wireplumber.service"
        ];
        wants = [
          "pipewire.service"
          "wireplumber.service"
        ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = toString (
            pkgs.writeShellScript "fix-cs35l56-mixer" ''
              # Resolve card index from stable PCI address to avoid
              # enumeration-order races with USB devices.
              card=$(basename /sys/bus/pci/devices/0000:65:00.6/sound/card*)
              idx=''${card#card}
              ${pkgs.alsa-utils}/bin/amixer -c "$idx" cset name='Master Playback Switch' on
              ${pkgs.alsa-utils}/bin/amixer -c "$idx" cset name='Master Playback Volume' 87
              ${pkgs.alsa-utils}/bin/amixer -c "$idx" cset name='Capture Switch' on,on
              ${pkgs.alsa-utils}/bin/amixer -c "$idx" cset name='Capture Volume' 41,41
            ''
          );
        };
      };

      # Re-pin mixer levels after resume from suspend.
      # System-level service runs as root after sleep.target and uses
      # machinectl/loginctl to restart the user unit in the active session.
      systemd.services.fix-cs35l56-mixer-resume = {
        description = "Re-pin ALSA hardware mixer for CS35L56 after resume";
        after = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
        ];
        wantedBy = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = toString (
            pkgs.writeShellScript "fix-cs35l56-mixer-resume" ''
              ${pkgs.systemd}/bin/systemctl --user -M 1000@ restart fix-cs35l56-mixer.service
            ''
          );
        };
      };
    };

  flake.modules.homeManager.sound =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pavucontrol
      ];
    };
}
