{
  configDest,
  homeDest,
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

  home.file."${homeDest "scripts"}" = {
    source = src "scripts";
    recursive = true;
    force = true;
  };
}
