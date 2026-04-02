{ config, ... }:
let
  _ = builtins.trace "TESTMKHYBRID FILE EVALUATING" null;
  helpers = config.flake.helpers;
in
{
  flake.modules.homeManager.testmkhybrid =
    { pkgs, ... }:
    {
      home.sessionVariables.TEST_FILE_LOADED = "yes";
    };
}
