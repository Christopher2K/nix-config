{
  configDest,
  src,
  ...
}:
{
  home.file."${configDest "opencode"}" = {
    source = src "opencode";
    force = true;
    recursive = true;
  };
}
