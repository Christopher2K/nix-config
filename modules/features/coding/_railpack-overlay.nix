# Overlay adding railpack, which isn't packaged in nixpkgs yet; use the
# official prebuilt binaries (static musl on Linux, ad-hoc signed Mach-O on
# macOS). Underscore prefix keeps import-tree from auto-importing this as a
# module; coding.nix pulls it in explicitly.
final: prev: {
  railpack = final.callPackage (
    {
      lib,
      stdenvNoCC,
      fetchurl,
    }:
    let
      version = "0.43.0";
      targets = {
        "x86_64-linux" = {
          target = "x86_64-unknown-linux-musl";
          hash = "sha256-JIqPYPNoVKq+1hJBE2MQeKgC3jRhZghV/E3pwmBlwfs=";
        };
        "aarch64-darwin" = {
          target = "arm64-apple-darwin";
          hash = "sha256-OFAmk0Encm/Q+bWhQxxa5EEGLqmVil+duw6YopFC1t4=";
        };
      };
      system = stdenvNoCC.hostPlatform.system;
      target = targets.${system} or (throw "railpack: unsupported system ${system}");
    in
    stdenvNoCC.mkDerivation {
      pname = "railpack";
      inherit version;

      src = fetchurl {
        url = "https://github.com/railwayapp/railpack/releases/download/v${version}/railpack-v${version}-${target.target}.tar.gz";
        inherit (target) hash;
      };

      # The tarball has files at its root instead of a single top-level dir.
      sourceRoot = ".";

      installPhase = ''
        runHook preInstall
        install -Dm755 railpack $out/bin/railpack
        runHook postInstall
      '';

      meta = {
        description = "Zero-config application packaging: build OCI images from source";
        homepage = "https://railpack.com";
        license = lib.licenses.mit;
        mainProgram = "railpack";
        platforms = builtins.attrNames targets;
      };
    }
  ) { };
}
