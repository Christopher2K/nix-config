{
  lib,
  config,
  ...
}:
{
  config.systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  # Custom types
  options.flake.username = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Username";
  };

  options.flake.helpers = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
    description = "Shared utilities";
  };

  # Custom options
  config.flake.username = "christopher";
  config.flake.helpers = {
    # Get a file or a directory from the assets folder.
    mkAssetsPath = filename_or_dir: ../assets + "${filename_or_dir}";
    mkAssetsStringPath =
      hmConfig: filename_or_dir: "${hmConfig.home.homeDirectory}/NixConfig/assets/${filename_or_dir}";
    # Get a path to the config folder
    mkConfigPath =
      hmConfig: filename_or_dir: "${hmConfig.home.homeDirectory}/.config/${filename_or_dir}";
    # Get a path to the home folder
    mkHomePath = hmConfig: filename_or_dir: "${hmConfig.home.homeDirectory}/${filename_or_dir}";

    # Create a hybrid Home Manager module that applies different configs based on platform
    mkHybrid =
      name:
      {
        linux ? null,
        darwin ? null,
        common ? null,
      }:
      {
        pkgs ? null,
        lib,
        ...
      }@args:
      if pkgs == null then
        { }
      else
        let
          isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
          platformFn = if isDarwin then darwin else linux;
          # Evaluate common config if provided
          commonCfg = if common != null then common args else { };
          # Evaluate platform-specific config if provided
          platformCfg = if platformFn != null then platformFn args else { };
          # Deep merge using recursiveUpdate
          merged = lib.recursiveUpdate commonCfg platformCfg;
          # Special handling for home.packages - concatenate them
          final =
            if commonCfg ? home.packages && platformCfg ? home.packages then
              merged // { home.packages = commonCfg.home.packages ++ platformCfg.home.packages; }
            else if commonCfg ? home.packages then
              merged // { home.packages = commonCfg.home.packages; }
            else if platformCfg ? home.packages then
              merged // { home.packages = platformCfg.home.packages; }
            else
              merged;
        in
        final;
  };
}
