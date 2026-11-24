{
  inputs,
  config,
  ...
}:
let
  helpers = config.flake.helpers;
  username = config.flake.username;
in
{
  flake.modules.nixos.remote-access = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.pippin.packages.${pkgs.system}.default
    ];
    hardware.uinput.enable = true;

    users.users.${username}.extraGroups = [ "uinput" ];

    services.tailscale.enable = true;

    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
      };
    };

    # VNC is only reachable over the tailnet, never on the LAN or internet.
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5900 ];

    # T3 Code server: reachable on the LAN for direct pairing.
    networking.firewall.interfaces.enp9s0.allowedTCPPorts = [ 3773 ];
  };

  flake.modules.darwin.remote-access = {
    services.tailscale.enable = true;
  };
}
