{
  pkgs,
  configDest,
  src,
  ...
}:
{
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
}
