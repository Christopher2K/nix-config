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
        ...
      }@args:
      let
        isDarwin = if pkgs != null then pkgs.stdenv.hostPlatform.isDarwin else false;
        platformFn = if isDarwin then darwin else linux;
        modules =
          lib.optional (common != null) (common args) ++ lib.optional (platformFn != null) (platformFn args);
      in
      if pkgs == null then { } else modules;
  };
}
