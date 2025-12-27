{
  configDest,
  homeDest,
  src,
  ...
}:

{
  home.file."${configDest "lf"}" = {
    source = src "lf";
    recursive = true;
    force = true;
  };
}
