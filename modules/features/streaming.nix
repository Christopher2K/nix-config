{ config, ... }:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.nixos.streaming = {
    # UxPlay uses DNS-SD to advertise the AirPlay receiver.
    services.avahi = {
      enable = true;
      openFirewall = true;
      settings.publish = {
        disable-publishing = false;
        disable-user-service-publishing = false;
        publish-addresses = true;
      };
    };

    # Legacy AirPlay ports selected by `uxplay -p`.
    networking.firewall = {
      allowedTCPPorts = [
        7000
        7001
        7100
      ];
      allowedUDPPorts = [
        6000
        6001
        7011
      ];
    };
  };

  flake.modules.darwin.streaming = {
    homebrew.casks = [
      "elgato-capture-device-utility"
      "elgato-stream-deck"
      "insta360-link-controller"
      "screen-studio"
      "obs"
    ];
  };

  flake.modules.darwin.streaming-cookunity = {
    homebrew.casks = [
      "screen-studio"
    ];
  };

  flake.modules.homeManager.streaming = helpers.mkHybrid {
    common = { pkgs, ... }: {
      home.packages = with pkgs; [ fdk_aac ];
    };

    linux = { pkgs, ... }: {
      home.packages = with pkgs; [ uxplay ];

      programs.obs-studio = {
        enable = true;
        plugins = [ pkgs.obs-studio-plugins.obs-vertical-canvas ];
      };
    };
  };
}
