{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "dt";
  version = "1.1.0";
  src = pkgs.fetchurl {
    url = "https://github.com/booniepepper/dt/releases/download/v${version}/x86_64-linux-gnu.tgz";
    sha256 = "sha256-ciU194O3ppG9IjgxY3HQ2+Fdr7QszxONWXNcN/tPFxA=";
  };
  unpackPhase = ''
    tar -xzf $src
  '';
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp x86_64-linux-gnu/bin/dt $out/bin/dt
  '';
  meta = {
    description = "dt binary";
    homepage = "https://github.com/booniepepper/dt";
  };
}
