# Plasticity 26.2.0 segfaults on launch (renderer process, V8 stack overflow)
# after its Electron 26 -> 42 bump. Pin to the last working version until fixed.
final: prev: {
  plasticity = prev.plasticity.overrideAttrs (old: rec {
    version = "26.1.4";
    src = final.fetchurl {
      url = "https://github.com/nkallen/plasticity/releases/download/v${version}/Plasticity-${version}-1.x86_64.rpm";
      hash = "sha256-paBF0lk8rvuY4lnl5v7nOXaFsZQuNkTtXCoW53xBiMU=";
    };
  });
}
