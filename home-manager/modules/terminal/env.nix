{
  homeDest,
  src,
  ...
}:
{
  home.file."${homeDest ".env.template"}" = {
    source = src ".env.template";
    force = true;
  };
}
