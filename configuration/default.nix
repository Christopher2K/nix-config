{
  username,
  config,
  pkgs,
  homebrew-cask,
  homebrew-core,
  neovim-nightly-overlay,
  ...
}:
{
  imports = [
    ./homebrew.nix
  ];

  nix = {
    # Disable darwin-nix self version management
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  environment.etc.nix-darwin.source = "/Users/${username}/dotfiles";

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

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

    defaults = {
      spaces.spans-displays = false; # For aerospace
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
      dock = {
        autohide = true;
        launchanim = false;
        magnification = false;
        mru-spaces = false;
        orientation = "right";
        # TODO: Custom this
        # persistent-apps = [ ];
        show-recents = false;
        tilesize = 24;
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
  };
}
