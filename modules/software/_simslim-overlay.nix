# Overlay adding simslim, which isn't packaged in nixpkgs yet; use the official
# prebuilt arm64 release binary so a rebuild never needs a Go toolchain.
# Underscore prefix keeps import-tree from auto-importing this as a module;
# coding.nix pulls it in explicitly.
final: prev: {
  simslim = final.callPackage (
    {
      lib,
      stdenvNoCC,
      fetchurl,
    }:
    let
      version = "0.15.0";
    in
    stdenvNoCC.mkDerivation {
      pname = "simslim";
      inherit version;

      src = fetchurl {
        url = "https://github.com/mobai-app/simslim/releases/download/v${version}/simslim-v${version}-macos-arm64.tar.gz";
        hash = "sha256-jbLXucQffLySXIg6KQeilB6Li/jW/IzEznNDqDDWGjE=";
      };

      # The tarball holds a single binary at its root, not a source tree.
      unpackPhase = ''
        tar xzf $src
      '';

      installPhase = ''
        runHook preInstall
        install -Dm755 simslim $out/bin/simslim
        runHook postInstall
      '';

      # Stripping rewrites the Mach-O and invalidates the ad-hoc code signature
      # the arm64 binary needs before macOS will execute it.
      dontStrip = true;

      meta = {
        description = "Run more iOS, tvOS, watchOS and visionOS simulators on one Mac";
        homepage = "https://github.com/MobAI-App/simslim";
        license = lib.licenses.mit;
        mainProgram = "simslim";
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        platforms = [ "aarch64-darwin" ];
      };
    }
  ) { };
}
