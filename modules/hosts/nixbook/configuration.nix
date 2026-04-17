{ inputs, config, ... }:
let
  username = config.flake.username;
in
{
  flake.modules.nixos.nixbookConfiguration =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.nixosModules.nixbookHardware
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.initrd.luks.devices."luks-b38e2595-9210-48d9-8869-601e610db49e".device =
        "/dev/disk/by-uuid/b38e2595-9210-48d9-8869-601e610db49e";

      networking.hostName = "nixbook";
      networking.wireless.enable = true;
      networking.networkmanager.enable = true;

      time.timeZone = "America/Toronto";

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
          "christopher"
        ];
      };

      environment.systemPackages = with pkgs; [
        appimage-run
        asusctl
        libgcc
        gcc
        gnumake
      ];

      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];

      system.stateVersion = "25.11";

      programs.nix-ld.enable = true;

      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      services.supergfxd.enable = true;
      services.asusd.enable = true;
    };
}
