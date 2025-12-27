{
  configDest,
  homeDest,
  src,
  ...
}:

{
  home.file."${homeDest "scripts"}" = {
    source = src "scripts";
    recursive = true;
    force = true;
  };
}
