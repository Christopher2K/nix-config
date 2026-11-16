{
  flake.modules.nixos.printing =
    { pkgs, ... }:
    {
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          hplip
          brlaser
        ];
      };

      # Network printer discovery (IPP Everywhere / DNS-SD) over mDNS.
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
}
