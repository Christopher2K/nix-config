{ inputs }:
final: prev: {
  herdr = inputs.herdr.packages.${prev.stdenv.hostPlatform.system}.default;
}
