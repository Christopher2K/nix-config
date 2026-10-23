{
  inputs,
  config,
  ...
}:
{
  flake.modules.darwin.browser = {

    homebrew.casks = [
      "helium-browser"
    ];
  };

  flake.modules.homeManager.browser = config.flake.helpers.mkHybrid {
    linux =
      {
        pkgs,
        ...
      }:
      let
        helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
      in
      {
        home.packages = [
          # Vicinae exports its own Qt 6.11 plugin path to child processes, but
          # Helium's Qt shim links against Qt 6.12 and aborts on the mismatch.
          (helium.overrideAttrs (old: {
            postFixup = (old.postFixup or "") + ''
              wrapProgram $out/bin/helium --unset QT_PLUGIN_PATH
            '';
          }))
        ];
      };
  };
}
