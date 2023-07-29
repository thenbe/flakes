{
  description = "dt";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # Systems supported
    allSystems = [
      "x86_64-linux" # 64-bit Intel/AMD Linux
    ];

    # Helper to provide system-specific attributes
    forAllSystems = f:
      nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    packages = forAllSystems ({pkgs}: {
      default = pkgs.stdenv.mkDerivation rec {
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
      };
    });
  };
}
