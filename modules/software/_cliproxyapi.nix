pkgs:
pkgs.stdenvNoCC.mkDerivation {
  pname = "cliproxyapi";
  version = "8.0.6";

  src = pkgs.fetchurl {
    url = "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.6/CLIProxyAPI_8.0.6_darwin_aarch64.tar.gz";
    hash = "sha256-4Z9zTNAHWZUe2osNshMBp4QpI7A6EPj6iDwZwnbkFpM=";
  };

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 cli-proxy-api "$out/bin/cliproxyapi"
    runHook postInstall
  '';
}
