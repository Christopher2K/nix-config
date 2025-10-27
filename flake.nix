{
  description = "Christopher's macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      homebrew-cask,
      homebrew-core,
      neovim-nightly-overlay,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      home-manager,
      ...
    }:

    let
      username = "christopher";
      aerospace-settings = import ./aerospace.nix;
      configuration =
        { pkgs, config, ... }:
        {
          nix = {
            # Disable darwin-nix self version management
            enable = false;

            # Necessary for using flakes on this system.
            settings.experimental-features = "nix-command flakes";
          };

          nixpkgs = {
            # The platform the configuration will be used on.
            hostPlatform = "aarch64-darwin";
            config.allowUnfree = true;
          };

          environment.etc.nix-darwin.source = "/Users/${username}/dotfiles";

          fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            # CLI
            pkgs.bat
            pkgs.fd
            pkgs.fzf
            pkgs.jankyborders
            pkgs.lazydocker
            pkgs.lazygit
            pkgs.lf
            pkgs.neofetch
            pkgs.opencode
            pkgs.ripgrep
            pkgs.scrcpy
            pkgs.starship
            pkgs.tmux
            pkgs.watchman

            # GUI
            pkgs._1password-gui
            pkgs.aerospace
            pkgs.discord
            pkgs.ghostty-bin
            pkgs.mise
            pkgs.nixfmt-rfc-style
            pkgs.orbstack
            pkgs.raycast
            pkgs.signal-desktop-bin
            pkgs.slack
            pkgs.tableplus
            pkgs.vlc-bin
            pkgs.whatsapp-for-mac
            pkgs.xcodes
            pkgs.yaak
            pkgs.zed-editor
            pkgs.zoom-us

            # Nightly stuff
            neovim-nightly-overlay.packages.${pkgs.system}.default
          ];

          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            mutableTaps = false;
            user = username;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
          };

          homebrew = {
            enable = true;
            brews = [ ];

            casks = [
              "android-studio"
              "arc"
              "bezel"
              "cleanshot"
              "daisydisk"
              "elgato-capture-device-utility"
              "elgato-stream-deck"
              "figma"
              "helium-browser"
              "insta360-link-controller"
              "intellij-idea-ce"
              "linear-linear"
              "localcan"
              "loopback"
              "notion"
              "obsidian"
              "screen-studio"
              "sketch"
              "transmission"
              "tuple"
              "virtualbuddy"
            ];
          };

          programs.tmux = {
            enable = true;
            enableMouse = true;
            extraConfig = ''
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Set base index to 1
set -g base-index 1
setw -g pane-base-index 1

# Status Bar
set -g status on
set -g status-style bg=#d5c4a1,fg=#594945
set -g status-interval 1
set -g status-justify left

set -g window-status-current-format "#[fg=#ebdbb2,bold bg=#af3a03] #{window_index}:#W "
set -g window-status-format "#[fg=#ebdbb4,bg=#a89984] #{window_index}:#W "
set -g window-status-separator ""

set -g status-left-length 40
set -g status-left-style default
set -g status-left "#{?client_prefix,⬇️,}#[fg=#FFFFFF,bold,bg=#7F6E63] #S "

set -g status-right-length 40
set -g status-right-style default
set -g status-right "#[fg=#ffffff,bold bg=#a89984] %H:%M "

unbind %
unbind '"'
bind \\ split-window -h
bind - split-window -v

bind h select-pane -L
bind l select-pane -R
bind k select-pane -U
bind j select-pane -D

run '~/.tmux/plugins/tpm/tpm'
'';
          };

          programs.zsh = {
            enable = true;
            enableFastSyntaxHighlighting = true;
            shellInit = "eval $(starship init zsh)";
          };

          services.aerospace = {
            enable = true;
            settings = aerospace-settings;
          };

          services.jankyborders = {
            enable = true;
            active_color = "0xfffe8019";
            hidpi = true;
            style = "round";
            width = 10.0;
            ax_focus = true;
            blacklist = [ "idea" "studio" ];
          };

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
            configurationRevision = self.rev or self.dirtyRev or null;

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
                NSWindowShouldDragOnGesture = { value = true; };
              };
            };
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Christophers-MacBook
      darwinConfigurations."Christophers-MacBook" = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          configuration
          (
            { config, ... }:
            {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            }
          )
        ];
      };
    };
}
