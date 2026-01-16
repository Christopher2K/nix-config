{
  username,
  config,
  ...
}:
{
  imports = [
    ./homebrew.nix
  ];

  # Disable darwin-nix self version management
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.etc.nix-darwin.source = "/Users/${username}/nix-config";

  users.users.${username}.home = "/Users/${username}";

  power.sleep = {
    computer = "never";
    display = 30;
    harddisk = "never";
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };

  system = {
    primaryUser = username;
    # Set Git commit hash for darwin-version.
    configurationRevision = config.rev or config.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  system.defaults = {
    spaces.spans-displays = false; # For aerospace
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
    dock = {
      autohide = true;
      launchanim = false;
      magnification = false;
      mru-spaces = false;
      orientation = "right";
      persistent-apps = [
        "/System/Applications/Mail.app"
        "/System/Applications/Calendar.app"
        "/Applications/Helium.app"
        "/Users/${username}/Applications/Home Manager Apps/Ghostty.app"
        "/Applications/Android Studio.app"
        "/Applications/IntelliJ IDEA CE.app"
        "/Applications/Figma.app"
        "/Applications/Obsidian.app"
      ];
      persistent-others = [
        "/Users/${username}/Developer"
        "/Users/${username}/Downloads"
      ];
      show-recents = false;
      tilesize = 36;
    };

    finder = {
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      NewWindowTarget = "Home";
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    WindowManager = {
      EnableTilingByEdgeDrag = false;
      EnableTilingOptionAccelerator = false;
      GloballyEnabled = false;
    };

    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
      Display = false;
      FocusModes = false;
      Sound = true;
    };

    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSTableViewDefaultSizeMode = 1;
      _HIHideMenuBar = false;
      "com.apple.keyboard.fnState" = true;
    };
    CustomUserPreferences = {
      # Enable ctrl+cmd+drag to move windows
      NSWindowShouldDragOnGesture = {
        value = true;
      };
    };
  };
}
