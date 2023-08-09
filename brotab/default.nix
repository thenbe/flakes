{ pkgs }:

let
  lua-shepi = pkgs.stdenv.mkDerivation {
    name = "lua-shepi";

    src = pkgs.fetchFromGitHub {
      owner = "forflo";
      repo = "shepi";
      rev = "e4a357fae6e160d8102566ea6fadadb146a152ff";
      sha256 = "sha256-HrpcZ+yO7O2+VBX7M8qyiEri8xr6svHI9L/c6lKntug=";
    };

    buildPhase = ''
      mkdir -p $out/lib
      cp -r $src/source/* $out/lib
    '';
  };

  luaEnv = pkgs.lua5_3.withPackages (ps: with ps; [
    luaposix
    lua
  ]);
in
pkgs.stdenv.mkDerivation {
  name = "brotab-modi";
  buildInputs = [ pkgs.makeWrapper luaEnv ];
  src = ./brotab-modi.lua;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/brotab-modi.lua
  '';

  # brotab (set it here since it doesn't seem to work when placed in buildInputs)
  # lua-shepi (set LUA_PATH so brotab-modi.lua can require('lua-shepi'))
  postFixup = ''
    wrapProgram $out/bin/brotab-modi.lua \
      --prefix PATH ":" ${pkgs.brotab}/bin \
      --prefix LUA_PATH ":" "${lua-shepi}/lib/?.lua"
  '';
}
