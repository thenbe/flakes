{
  description = "thenbe's flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        aider = pkgs.callPackage ./aider/default.nix { };
        brotab-modi = pkgs.callPackage ./brotab/default.nix { };
        crawley = pkgs.callPackage ./crawley/default.nix { };
        dt = pkgs.callPackage ./dt/default.nix { };
        katana = pkgs.callPackage ./katana/default.nix { };
        tableplus = pkgs.callPackage ./tableplus/default.nix { };
        play = pkgs.callPackage ./play/default.nix { };
      in
      {
        packages = {
          inherit aider;
          inherit brotab-modi;
          inherit crawley;
          inherit katana;
          inherit dt;
          inherit tableplus;
          inherit play;
        };

        apps = {
          brotab-modi = { program = "${brotab-modi}/bin/brotab-modi.lua"; type = "app"; };
        };

        devShells = {
          aider = pkgs.mkShell { packages = [ aider pkgs.universal-ctags ]; };
        };

        # flakes = { };
      }
    );
}
