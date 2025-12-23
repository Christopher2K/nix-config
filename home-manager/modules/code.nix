{
  inputs,
  pkgs,
  lib,
  configDest,
  src,
  ...
}:
{
  ############
  # Git      #
  ############
  home.file."${configDest "gitconfig-cookunity"}" = {
    source = src "gitconfig-cookunity";
    force = true;
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
    };

    includes = [
      {
        path = configDest ".config/git/gitconfig-cookunity";
        condition = "gitdir:**/cookunity/**";
      }
    ];
  };

  ############
  # OpenCode #
  ############
  home.file."${configDest "opencode"}" = {
    source = src "opencode";
    force = true;
    recursive = true;
  };

  ############
  # Neovim   #
  ############
  home.file."${configDest "nvim"}" = {
    source = src "nvim";
    recursive = true;
    force = true;
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  ############
  # Mise     #
  ############
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      settings = {
        all_compile = false;
      };
      tools = {
        bun = "1.2.2";
        elixir = "1.18.4-otp-28";
        erlang = "28.0.2";
        gleam = "1.13.0";
        golang = "1.22.2";
        java = "openjdk-17.0.2";
        kotlin = "2.0.0";
        nodejs = "22.11.0";
        ocaml = "5.4.0";
        opam = "2.2.0";
        python = "3.12.0";
        ruby = "3.2.9";
        rust = "1.75.0";
      };
    };
  };
  # Not working -- Says stuff like curl are missing
  # home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   ${pkgs.mise}/bin/mise install
  # '';

  ############
  # Direnv   #
  ############
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
    mise.enable = true;
  };

}
