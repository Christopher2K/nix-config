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

      # WirePlumber restores saved ALSA state on boot that soft-mixer
      # won't override. Pin hardware mixer to nominal levels.
      systemd.services.fix-cs35l56-mixer = {
        description = "Pin ALSA hardware mixer for CS35L56 soft-mixer";
        after = [ "sound.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = toString (
            pkgs.writeShellScript "fix-cs35l56-mixer" ''
              sleep 2
              ${pkgs.alsa-utils}/bin/amixer -c 2 cset numid=25 on
              ${pkgs.alsa-utils}/bin/amixer -c 2 cset numid=24 87
              ${pkgs.alsa-utils}/bin/amixer -c 2 cset numid=21 on,on
              ${pkgs.alsa-utils}/bin/amixer -c 2 cset numid=20 41,41
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
