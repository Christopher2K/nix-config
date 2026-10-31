{ inputs, config, ... }:
let
  username = config.flake.username;
  helpers = config.flake.helpers;
  overlays = [
    # inputs.neovim-nightly-overlay.overlays.default
    (import ./_railpack-overlay.nix)
    (import ./_sqlit-overlay.nix { inherit inputs; })
  ];
in
{
  flake.modules.nixos.coding =
    { pkgs, ... }:
    {
      nixpkgs.overlays = overlays;

      users.users.${username}.extraGroups = [ "kvm" ];
      environment.systemPackages = [
        pkgs.miktex
      ];
    };

  flake.modules.darwin.coding = { pkgs, ... }: {
    nixpkgs.overlays = overlays;

    homebrew.brews = [
      "xcodegen"
      "libyaml"
      "gh"
    ];

    homebrew.casks = [
      "miktex-console"
      "android-studio"
      "localcan"
      "xcodes-app"
    ];
  };

  flake.modules.homeManager.coding = helpers.mkHybrid {
    common =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        home.file."${helpers.mkConfigPath config "/nvim"}".source = config.lib.file.mkOutOfStoreSymlink (
          helpers.mkAssetsStringPath config "/nvim"
        );

        home.file."${helpers.mkConfigPath config "/git/gitconfig-cookunity"}" = {
          source = helpers.mkAssetsPath "/gitconfig-cookunity";
          force = true;
        };

        # SSH commit signing via the Proton Pass SSH agent: the private key
        # lives in Proton Pass (synced across hosts). git shells out to the
        # `proton-pass-sign` wrapper below (gpg.ssh.program), which points
        # SSH_AUTH_SOCK at the agent socket and execs ssh-keygen. The public
        # key is committed in the repo so git can pass it to ssh-keygen (-f).
        home.file."${helpers.mkHomePath config "/.ssh/git_signing_key.pub"}" = {
          source = helpers.mkAssetsPath "/git-signing-key.pub";
          force = true;
        };

        home.file."${helpers.mkHomePath config "/.ssh/proton-pass-sign"}" = {
          executable = true;
          text = ''
            #!/bin/sh
            # Git SSH signing helper (gpg.ssh.program): sign with the key
            # stored in Proton Pass instead of an on-disk private key.
            export SSH_AUTH_SOCK="$HOME/.ssh/proton-pass-agent.sock"

            if [ ! -S "$SSH_AUTH_SOCK" ]; then
              echo "proton-pass-sign: Proton Pass agent socket not found at $SSH_AUTH_SOCK" >&2
              echo "Start Proton Pass (SSH agent enabled) to sign commits." >&2
              exit 1
            fi

            exec ssh-keygen "$@"
          '';
        };

        # allowed_signers for `git log --show-signature` / `git verify-commit`
        # (GitHub verification uses the key registered on the account instead).
        # The second principal covers the work identity used in */cookunity/* repos.
        home.file."${helpers.mkHomePath config "/.ssh/allowed_signers"}".text =
          "me@christopher2k.dev,christopherkatoyi@cookunity.com ${lib.removeSuffix "\n" (builtins.readFile (helpers.mkAssetsPath "/git-signing-key.pub"))}\n";

        home.packages = [
          # t3 CLI + desktop app (t3code-desktop); no upstream flake, packaged in
          # nixpkgs. Installed on every host; the background-service secrets it
          # needs are set up by the workstation feature.
          pkgs.t3code
          pkgs.devenv
          pkgs.lazydocker
          pkgs.lazygit
          pkgs.railpack
          pkgs.sqlit
          pkgs.zed-editor
        ]
        ++ [
          inputs.tree-sitter.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

        programs.neovim = {
          enable = true;
          package = pkgs.neovim-unwrapped;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          # Avoid HM writing ~/.config/nvim/init.lua (conflicts with our
          # out-of-store symlink to assets/nvim). HM's auto-generated initLua
          # (provider disables, plugin configs) is injected via a wrapper
          # --cmd flag instead.
          sideloadInitLua = true;
        };

        programs.git = {
          enable = true;
          ignores = [
            ".bloop/"
            ".DS_STORE"
          ];
          settings = {
            user.email = "me@christopher2k.dev";
            user.name = "Christopher N. Katoyi Kaba";
            pull.rebase = true;
            init.defaultBranch = "main";
            rerere.enabled = true;
            # Sign commits with the "Github Christopher2K Key" stored in the
            # Proton Pass SSH agent (wrapper + public key installed above).
            # Repos under */cookunity/* override the identity via the included
            # gitconfig; signing still applies unless disabled there.
            commit.gpgsign = true;
            gpg.format = "ssh";
            gpg.ssh.program = "${config.home.homeDirectory}/.ssh/proton-pass-sign";
            gpg.ssh.allowedsignersfile = "${config.home.homeDirectory}/.ssh/allowed_signers";
            user.signingkey = "${config.home.homeDirectory}/.ssh/git_signing_key.pub";
          };

          includes = [
            {
              path = helpers.mkConfigPath config "/git/gitconfig-cookunity";
              condition = "gitdir:**/cookunity/**";
            }
          ];
        };

        programs.direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };

    darwin =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          orbstack
          tableplus
        ];

        # Version manager for macOS only. On NixOS, toolchains come
        # straight from nixpkgs (see the linux block below).
        programs.mise = {
          enable = true;
          enableZshIntegration = true;
          globalConfig = {
            settings = {
              all_compile = false;
            };
            tools = {
              bun = "1.3.11";
              elixir = "1.18.4-otp-28";
              erlang = "28.0.2";
              gleam = "1.13.0";
              java = "openjdk-17.0.2";
              kotlin = "2.0.0";
              nodejs = "24.13.0";
              python = "3.12.0";
              ruby = "3.2.9";
              rust = "1.96.1";
              golang = "1.26.0";
            };
          };
        };

        programs.direnv.mise.enable = true;
      };

    linux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # Global dev toolchains (replacing mise on NixOS).
          # Per-project versions: use a flake devShell or devenv
          # with direnv (`use flake` / `use devenv` in .envrc).
          beam28Packages.erlang
          beam28Packages.elixir_1_18
          bun
          cargo
          clippy
          gleam
          go_1_26
          jdk17
          kotlin
          nodejs_24
          python312
          ruby_3_4
          rustc
          rustfmt
        ];
      };
  };
}
