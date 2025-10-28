{
  pkgs,
  getConfig,
  getDest,
  ...
}:
{
  home.file."${getDest "gitconfig-cookunity"}" = {
    source = getConfig "gitconfig-cookunity";
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
        path = "${getDest ".config/git/gitconfig-cookunity"}";
        condition = "gitdir:**/cookunity/**";
      }
    ];
  };
}
