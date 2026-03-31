{
  config,
  ...
}:
{
  flake.modules.nixos.splashscreen =
    { ... }:
    {
      # Silent boot - more aggressive settings to prevent black flash
      boot.consoleLogLevel = 0;

      boot.initrd = {
        verbose = false;
        # Need that for luks stuff
        systemd.enable = true;
      };

      boot.kernelParams = [
        "quiet"
        "splash"
        "udev.log_level=3"
        "systemd.show_status=auto"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
        "loglevel=0"
      ];

      # Do not show prev generations
      boot.loader.timeout = 0;

      boot.plymouth = {
        enable = true;
        theme = "bgrt";
        extraConfig = ''
          [Daemon]
          ShowDelay=0
        '';
      };
    };
}
