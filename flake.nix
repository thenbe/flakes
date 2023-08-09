{
  description = "thenbe's flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    dt.url = "path:./dt";
    tableplus.url = "path:./tableplus";
  };

  outputs = { self, nixpkgs, flake-utils, dt, tableplus }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        aider = pkgs.callPackage ./aider/default.nix { };
        brotab-modi = pkgs.callPackage ./brotab/default.nix { };
        crawley = pkgs.callPackage ./crawley/default.nix { };
      in
      {
        packages = {
          inherit aider;
          inherit brotab-modi;
          inherit crawley;
          dt = dt.outputs.packages.${system}.default;
          tableplus = tableplus.outputs.packages.${system}.default;
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
