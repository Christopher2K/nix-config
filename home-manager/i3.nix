{
  getDest,
  getConfig,
  ...
}:
{
  home.file."${getDest ".config/i3"}" = {
    source = getConfig "i3";
    recursive = true;
  };
}
