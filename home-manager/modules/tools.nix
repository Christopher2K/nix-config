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

  home.file."${configDest "lf"}" = {
    source = src "lf";
    recursive = true;
    force = true;
  };
}
