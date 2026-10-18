{ inputs, config, ... }:
let
  username = config.flake.username;
  helpers = config.flake.helpers;
  overlays = [
    (final: prev: {
      herdr = inputs.herdr.packages.${prev.stdenv.hostPlatform.system}.default;
    })
  ];
in
{
  flake.modules.nixos.terminal =
    { pkgs, ... }:
    {
      console.useXkbConfig = true;
      programs.zsh.enable = true;
      users.users.${username}.shell = pkgs.zsh;

      nixpkgs.overlays = overlays;
    };

  flake.modules.darwin.terminal = {
    nixpkgs.overlays = overlays;
  };

  flake.modules.homeManager.terminal =

    helpers.mkHybrid {
      darwin = {
        home.sessionVariables = {
          # Android
          ANDROID_ROOT = "$HOME/Library/Android";
          ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk";
          ANDROID_PLATFORM_TOOLS = "$HOME/Library/Android/sdk/platform-tools";
          ANDROID_HOME = "$HOME/Library/Android/sdk";
          PATH = "$PATH:$ANDROID_PLATFORM_TOOLS:$HOME/Library/Android/sdk/emulator";
        };
      };

      linux = {
        home.sessionVariables = {
          # Android
          ANDROID_ROOT = "$HOME/Android";
          ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
          ANDROID_PLATFORM_TOOLS = "$HOME/Android/Sdk/platform-tools";
          ANDROID_HOME = "$HOME/Android/Sdk";
          PATH = "$PATH:$ANDROID_PLATFORM_TOOLS:$HOME/Android/Sdk/emulator";
        };
      };

      common =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {
          home.packages = with pkgs; [
            herdr
          ];

          home.file."${helpers.mkHomePath config "/Scripts"}" = {
            source = helpers.mkAssetsPath "/scripts";
            recursive = true;
            force = true;
          };

          home.file."${helpers.mkConfigPath config "/.env.template"}" = {
            source = helpers.mkAssetsPath "/env.template";
            force = true;
          };

          # Out-of-store symlink so herdr can write settings (e.g. onboarding)
          # back to the config file at runtime without hitting the read-only
          # Nix store.
          home.file."${helpers.mkConfigPath config "/herdr/config.toml"}".source =
            config.lib.file.mkOutOfStoreSymlink (helpers.mkAssetsStringPath config "/herdr/config.toml");

          home.sessionVariables = {
            LC_ALL = "en_US.UTF-8";
            LC_CTYPE = "en_US.UTF-8";
            TMPDIR = "$HOME/.tmp";

            DEV = "$HOME/Developer";

            SSH_AUTH_SOCK = "$HOME/.ssh/proton-pass-agent.sock";

            SHELL_SESSIONS_DISABLE = 1;

            # Erlang
            ERL_AFLAGS = "-kernel shell_history enabled";

            TERMINAL = "kitty";
          };

          home.shell.enableShellIntegration = true;

          programs.kitty = {
            enable = true;

            shellIntegration.enableZshIntegration = true;

            # Match the visual settings from the old Ghostty config.
            settings = {
              window_padding_width = 12;
              hide_window_decorations = "titlebar-only";
              macos_option_as_alt = true;
              initial_working_directory = "$HOME";
              remember_window_size = false;
            };

            # Ghostty used a larger font size on macOS to compensate for its
            # default 72 DPI; scale kitty's point size to match.
            font.size = lib.mkForce (
              if pkgs.stdenv.isDarwin then 10.0 * 4.0 / 3.0 else config.stylix.fonts.sizes.terminal
            );
          };

          programs.zsh = {
            enable = true;
            oh-my-zsh.enable = true;

            # Enable built-in completions (faster than oh-my-zsh)
            enableCompletion = false;
            completionInit = ''
              autoload -Uz compinit
              # Only regenerate .zcompdump once a day for faster startup
              if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
                compinit
              else
                compinit -C
              fi
            '';

            shellAliases = {
              "switch" =
                if pkgs.stdenv.isDarwin then "sudo darwin-rebuild switch" else "sudo nixos-rebuild switch";

              # Git aliases (replacing oh-my-zsh git plugin - only the commonly used ones)
              g = "git";
              ga = "git add";
              gaa = "git add --all";
              gb = "git branch";
              gc = "git commit";
              gcm = "git commit -m";
              gco = "git checkout";
              gd = "git diff";
              gf = "git fetch";
              gl = "git pull";
              gp = "git push";
              gst = "git status";
              glog = "git log --oneline --decorate --graph";
            };

            initContent =
              let
                zshConfigEarlyInit = lib.mkOrder 500 ''
                  source ~/.runtimerc 2>/dev/null || true

                  delete_localonly_branches () {
                    git fetch -p

                    for branch in $(git branch --format "%(refname:short)"); do
                      if ! git show-ref --quiet refs/remotes/origin/$branch; then
                        echo "Delete local $branch"
                        git branch -D $branch
                      fi
                    done
                  }

                  alias delete_localonly_branch="delete_localonly_branches"

                  # Load cached environment variables
                  CACHE_FILE="$HOME/.cache/env/.env.cache"

                  if [ -f "$CACHE_FILE" ]; then
                    source "$CACHE_FILE"
                  else
                    echo "⚠️  No cached environment variables found. Running: ~/Scripts/secure-env-refresh"
                    ~/Scripts/secure-env-refresh.sh
                    source "$CACHE_FILE"
                  fi
                '';

                # devenv auto-activation: https://devenv.sh/auto-activation/#setup
                zshConfigDevenvHook = ''
                  eval "$(devenv hook zsh)"
                '';
              in
              lib.mkMerge [
                zshConfigEarlyInit
                zshConfigDevenvHook
              ];
          };

          programs.starship = {
            enable = true;
            settings = {
              command_timeout = 1000;
              format = "$character$directory";
              right_format = "$all";

              # Disable slow/unused modules for faster prompt rendering
              ruby.detect_variables = [ ];
              aws.disabled = true;
              gcloud.disabled = true;
              package.disabled = true;

              cmd_duration = {
                min_time = 0;
                show_milliseconds = false;
              };

              # Git optimizations - only check in git dirs, skip slow operations
              git_status = {
                disabled = false;
                ignore_submodules = true;
              };
            };
          };
        };
    };
}
