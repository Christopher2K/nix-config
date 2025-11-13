{
  getDest,
  getConfig,
  ...
}:
{
  home.file."${getDest ".config/opencode/opencode.json"}" = {
    source = getConfig "opencode/opencode.json";
  };
}
