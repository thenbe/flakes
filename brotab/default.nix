{ pkgs }:
let
  luaEnv = pkgs.lua5_3.withPackages (ps: with ps; [
    luaposix
    lua-shepi # TODO: use custom nixpkgs only for lua-shepi
    lua
  ]);
in
pkgs.stdenv.mkDerivation {
  name = "brotab-modi";
  buildInputs = [ pkgs.makeWrapper pkgs.brotab luaEnv ];
  src = ./brotab-modi.lua;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/brotab-modi.lua
    chmod +x $out/bin/brotab-modi.lua
    wrapProgram $out/bin/brotab-modi.lua --prefix PATH : ${pkgs.brotab}/bin
  '';
}
