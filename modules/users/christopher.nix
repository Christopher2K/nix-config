{
  config,
  ...
}:
{
  flake.modules.homeManager.christopher = {
    home.username = config.flake.username;
    home.stateVersion = "26.05";
  };
}
