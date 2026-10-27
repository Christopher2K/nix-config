{
  inputs,
  config,
  ...
}:
let
  username = config.flake.username;
in
{
  flake.modules.nixos.nixstationConfiguration =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.nixosModules.nixstationHardware
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.systemd-boot.configurationLimit = 5;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostName = "nixstation";
      networking.networkmanager.enable = true;

      time.timeZone = null;
      services.automatic-timezoned.enable = true;
      services.geoclue2.enable = true;

      i18n.defaultLocale = "en_CA.UTF-8";

      services.xserver.xkb = {
        layout = "us";
        variant = "altgr-intl";
        options = "caps:escape";
      };

      users.users.${username} = {
        isNormalUser = true;
        description = "Christopher Katoyi Kaba";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };

      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = [
          "root"
          username
        ];
      };

      nix.gc.automatic = true;
      nix.gc.options = "--delete-older-than 7d";

      environment.systemPackages = with pkgs; [
        accountsservice
        appimage-run
        libgcc
        gcc
        gnumake
        wine
      ];

      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];

      system.stateVersion = "26.05";

      programs.nix-ld.enable = true;
    };
}
