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

    # Create a hybrid Home Manager module that applies platform-specific config.
    # Usage:
    #   flake.modules.homeManager.foo = helpers.mkHybrid "foo" {
    #     common = { pkgs, config, ... }: { ... };   # applied on all platforms
    #     linux  = { pkgs, config, ... }: { ... };   # applied on Linux only
    #     darwin = { pkgs, config, ... }: { ... };   # applied on macOS only
    #   };
    # Any of common/linux/darwin may be omitted or set to null.
    mkHybrid =
      _name:
      {
        linux ? null,
        darwin ? null,
        common ? null,
      }:
      # This is a valid Home Manager module function. HM calls it with full args.
      {
        pkgs ? null,
        lib,
        ...
      }:
      let
        isDarwin = if pkgs != null then pkgs.stdenv.hostPlatform.isDarwin else false;
        platformMod = if isDarwin then darwin else linux;
      in
      {
        imports = lib.optional (common != null) common ++ lib.optional (platformMod != null) platformMod;
      };
  };
}
