{ inputs, config, ... }:
let
  username = config.flake.username;
  helpers = config.flake.helpers;
  overlays = [
    # inputs.neovim-nightly-overlay.overlays.default
    (final: prev: {
      # snowflake-connector-python's tests fail on Python 3.14 (event-loop +
      # permission assertion issues); skip checks so sqlit can build.
      python3 = prev.python3.override {
        packageOverrides = pyFinal: pyPrev: {
          snowflake-connector-python = pyPrev.snowflake-connector-python.overridePythonAttrs (old: {
            doCheck = false;
            dontCheckRuntimeDeps = true;
          });
        };
      };

      # Rebuild sqlit from the upstream flake against our python3 so the
      # snowflake override applies (the flake's own packages close over
      # nixpkgs.legacyPackages and can't see our overlays).
      sqlit =
        let
          pyPkgs = final.python3.pkgs;
          version = "0.0.0+${inputs.sqlit.shortRev or "dirty"}";
        in
        pyPkgs.buildPythonApplication {
          pname = "sqlit";
          inherit version;
          pyproject = true;

          src = inputs.sqlit;

          build-system = [
            pyPkgs.hatchling
            pyPkgs."hatch-vcs"
            pyPkgs."setuptools-scm"
          ];

          nativeBuildInputs = [ pyPkgs.pythonRelaxDepsHook ];
          pythonRelaxDeps = [ "textual-fastdatatable" ];

          postPatch = ''
            export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
            export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_SQLIT_TUI="${version}"
          '';

          dependencies = [
            pyPkgs.docker
            pyPkgs.keyring
            pyPkgs.pyperclip
            pyPkgs.sqlparse
            pyPkgs.textual
            pyPkgs."textual-fastdatatable"
            # extras (mirrors upstream nixpkgsExtras)
            pyPkgs.sshtunnel
            pyPkgs.paramiko
            pyPkgs.psycopg2
            pyPkgs.pymysql
            pyPkgs.duckdb
            pyPkgs.google-cloud-bigquery
            pyPkgs.snowflake-connector-python
            pyPkgs.requests
          ];

          pythonImportsCheck = [ "sqlit" ];

          meta = {
            description = "A terminal UI for SQL databases";
            homepage = "https://github.com/Maxteabag/sqlit";
            license = prev.lib.licenses.mit;
            mainProgram = "sqlit";
          };
        };
    })
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
      { pkgs, config, ... }:
      {
        home.file."${helpers.mkConfigPath config "/nvim"}".source = config.lib.file.mkOutOfStoreSymlink (
          helpers.mkAssetsStringPath config "/nvim"
        );

        home.file."${helpers.mkConfigPath config "/git/gitconfig-cookunity"}" = {
          source = helpers.mkAssetsPath "/gitconfig-cookunity";
          force = true;
        };

        home.packages = [
          pkgs.devenv
          pkgs.lazydocker
          pkgs.lazygit
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
