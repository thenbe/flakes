{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:thenbe/nixpkgs/lua-shepi-1.4.1"; # TODO: only for lua-shepi
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        luaEnv = pkgs.lua5_3.withPackages (ps: with ps; [
          luaposix
          lua-shepi
        ]);
        brotab-modi = pkgs.stdenv.mkDerivation {
          name = "brotab-modi";
          buildInputs = [ pkgs.brotab ];
          propagatedBuildInputs = [ luaEnv pkgs.lua5_3 ];
          src = ./brotab-modi.lua;
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/brotab-modi
            chmod +x $out/bin/brotab-modi
          '';
        };
      in
      {
        packages = {
          default = brotab-modi;
          inherit brotab-modi;
        };
        apps.brotab-modi = {
          type = "app";
          program = "${brotab-modi}/bin/brotab-modi";
        };
      }
    );
}
