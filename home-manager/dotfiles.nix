let 
  getConfig = filename : ./configuration-files/${filename};
  getDest = filename : "./.config/${filename}";
in {
  home.file."${getDest "aerospace/aerospace.toml"}" = {
    source = getConfig "aerospace.toml";
  };
}
