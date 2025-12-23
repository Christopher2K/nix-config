{
  configDest,
  src,
  ...
}:

{
  home.file."${configDest "glow"}" = {
    source = src "glow";
    recursive = true;
    force = true;
  };
}
