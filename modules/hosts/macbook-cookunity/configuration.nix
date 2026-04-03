{
  config,
  ...
}:
{
  flake.modules.darwin.macbookCookUnityConfiguration =
    config.flake.modules.darwin.macbookConfiguration;
}
