{
  pkgs,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;
    # Disabled oh-my-zsh for faster shell startup
    oh-my-zsh.enable = false;

    # Enable built-in completions (faster than oh-my-zsh)
    enableCompletion = true;
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

    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      TMPDIR = "$HOME/.tmp";

      # ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOQUIT = "false";

      DEV = "$HOME/Developer";
      COOKIN = "$DEV/cookin";

      # Android
      ANDROID_ROOT = "$HOME/Library/Android";
      ANDROID_SDK_ROOT = "$ANDROID_ROOT/sdk";
      ANDROID_PLATFORM_TOOLS = "$ANDROID_SDK_ROOT/platform-tools";
      ANDROID_HOME = "$ANDROID_SDK_ROOT";
      PATH = "$PATH:$ANDROID_PLATFORM_TOOLS";

      # Erlang
      ERL_AFLAGS = "-kernel shell_history enabled";
    };

    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
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

          # Load cached environment variables from 1Password
          CACHE_FILE="$HOME/.cache/env/.env.cache"

          if [ -f "$CACHE_FILE" ]; then
            source "$CACHE_FILE"
          else
            echo "⚠️  No cached environment variables found. Running: ~/scripts/secure-env-refresh"
            ~/scripts/secure-env-refresh.sh
            source "$CACHE_FILE"
          fi

          # sudo plugin replacement: press ESC ESC to prepend sudo
          sudo-command-line() {
            [[ -z $BUFFER ]] && zle up-history
            [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
            zle end-of-line
          }
          zle -N sudo-command-line
          bindkey '\e\e' sudo-command-line
        '';
        zshConfig = lib.mkOrder 1500 ''
          # Lazy-load OPAM: only initialize when first calling opam/ocaml/dune
          _opam_lazy_init() {
            unfunction opam ocaml dune 2>/dev/null
            [[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1
          }
          opam() { _opam_lazy_init; opam "$@" }
          ocaml() { _opam_lazy_init; ocaml "$@" }
          dune() { _opam_lazy_init; dune "$@" }
        '';

      in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
      ];
  };
}
