{
  getDest,
  getConfig,
  ...
}:
{
  home.file."${getDest ".config/lf"}" = {
    source = getConfig "lf";
    recursive = true;
  };
}
