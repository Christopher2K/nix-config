{
  config,
  inputs,
  lib,
  ...
}:
let
  username = config.flake.username;
in
{
  flake.modules.darwin.system = {
    # Disable nix-darwin self version management
    nix.enable = false;

    nixpkgs.hostPlatform = "aarch64-darwin";

    environment.etc.nix-darwin.source = lib.mkDefault "/Users/${username}/NixConfig";

    users.users.${username}.home = lib.mkDefault "/Users/${username}";

    power.sleep = {
      computer = lib.mkDefault "never";
      display = lib.mkDefault 30;
      harddisk = lib.mkDefault "never";
    };

    security.pam.services.sudo_local = {
      enable = lib.mkDefault true;
      reattach = lib.mkDefault true;
      touchIdAuth = lib.mkDefault true;
    };

    system = {
      primaryUser = lib.mkDefault username;
      # Set Git commit hash for darwin-version.
      configurationRevision = lib.mkDefault (config.rev or config.dirtyRev or null);

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      stateVersion = lib.mkDefault 6;

      keyboard = {
        enableKeyMapping = lib.mkDefault true;
        remapCapsLockToEscape = lib.mkDefault true;
      };
    };

    system.defaults = {
      spaces.spans-displays = lib.mkDefault false; # For aerospace
      dock.expose-group-apps = lib.mkDefault true; # For aerospace
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = lib.mkDefault false;
      dock = {
        autohide = lib.mkDefault true;
        launchanim = lib.mkDefault false;
        magnification = lib.mkDefault false;
        mru-spaces = lib.mkDefault false;
        orientation = lib.mkDefault "right";
        show-recents = lib.mkDefault false;
        tilesize = lib.mkDefault 36;
      };

      finder = {
        AppleShowAllFiles = lib.mkDefault true;
        FXEnableExtensionChangeWarning = lib.mkDefault false;
        NewWindowTarget = lib.mkDefault "Home";
        ShowHardDrivesOnDesktop = lib.mkDefault true;
        ShowMountedServersOnDesktop = lib.mkDefault true;
        ShowPathbar = lib.mkDefault true;
        ShowStatusBar = lib.mkDefault true;
      };

      WindowManager = {
        EnableTilingByEdgeDrag = lib.mkDefault false;
        EnableTilingOptionAccelerator = lib.mkDefault false;
        GloballyEnabled = lib.mkDefault false;
      };

      controlcenter = {
        BatteryShowPercentage = lib.mkDefault true;
        Bluetooth = lib.mkDefault true;
        Display = lib.mkDefault false;
        FocusModes = lib.mkDefault false;
        Sound = lib.mkDefault true;
      };

      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = lib.mkDefault true;
        ApplePressAndHoldEnabled = lib.mkDefault false;
        AppleShowAllExtensions = lib.mkDefault true;
        AppleShowAllFiles = lib.mkDefault true;
        NSAutomaticCapitalizationEnabled = lib.mkDefault false;
        NSAutomaticWindowAnimationsEnabled = lib.mkDefault false;
        NSTableViewDefaultSizeMode = lib.mkDefault 1;
        _HIHideMenuBar = lib.mkDefault false;
        "com.apple.keyboard.fnState" = lib.mkDefault true;
      };

      CustomUserPreferences = {
        # Enable ctrl+cmd+drag to move windows
        NSWindowShouldDragOnGesture.value = lib.mkDefault true;
      };
    };
  };
}
