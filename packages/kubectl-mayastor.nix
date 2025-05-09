{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "kubectl-mayastor";
  src = pkgs.fetchurl {
    url = "https://github.com/openebs/mayastor-extensions/releases/download/v2.8.0/kubectl-mayastor-x86_64-linux-musl.tar.gz";
    sha256 = "sha256-MAmAk33LxbjXQfC8TvsUuWz8EzO5PblJU44wJk6H9iY=";
  };
  sourceRoot = ".";
  phases = ["unpackPhase" "installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp kubectl-mayastor $out/bin/kubectl-mayastor
    chmod +x $out/bin/kubectl-mayastor
  '';
}
