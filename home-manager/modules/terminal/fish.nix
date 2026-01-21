{
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;

    shellAliases = {
      "rebuild" =
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
      delete_localonly_branch = "delete_localonly_branches";
    };

    functions = {
      delete_localonly_branches = ''
        git fetch -p

        for branch in (git branch --format "%(refname:short)")
          if not git show-ref --quiet refs/remotes/origin/$branch
            echo "Delete local $branch"
            git branch -D $branch
          end
        end
      '';
    };

    shellInit = ''
      # Load cached environment variables from 1Password
      set CACHE_FILE "$HOME/.cache/env/.env.cache"

      if test -f "$CACHE_FILE"
        source "$CACHE_FILE"
      else
        echo "⚠️  No cached environment variables found. Running: ~/scripts/secure-env-refresh"
        ~/scripts/secure-env-refresh.fish
        source "$CACHE_FILE"
      end
    '';
  };
}
