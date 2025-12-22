{
  getDest,
  getConfig,
  ...
}:
{
  home.file."${getDest ".config/hypr"}" = {
    source = getConfig "hypr";
    recursive = true;
  };
}
