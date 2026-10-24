{
  flake.modules.darwin.sound = {
    home.brews = [
      "loopback"
    ];
  };

  flake.modules.nixos.sound =
    { ... }:
    {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
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
    };

  flake.modules.homeManager.sound =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pavucontrol
      ];
    };
}
