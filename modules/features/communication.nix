{
  config,
  inputs,
  ...
}:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.darwin.communication = {
    homebrew.casks = [
      "whatsapp"
      "signal"
      "slack"
      "insta360-link-controller"
      "zoom"
      "localsend"
    ];
  };

  flake.modules.nixos.communication = {
    # LocalSend discovery and file transfers both use port 53317.
    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };

  flake.modules.homeManager.communication = helpers.mkHybrid {
    linux = { pkgs, ... }: {
      home.packages = with pkgs; [
        beeper
        discord
        thunderbird
        localsend
      ];
    };
  };

}
