{
  description = "thenbe's flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    lua-shepi-nixpkgs.url = "github:thenbe/nixpkgs/lua-shepi-1.4.1"; # TODO: only for lua-shepi
    dt.url = "path:./dt";
    tableplus.url = "path:./tableplus";
  };

  outputs = { self, nixpkgs, flake-utils, lua-shepi-nixpkgs, dt, tableplus }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        aider = pkgs.callPackage ./aider/default.nix { };
        brotab-modi = pkgs.callPackage ./brotab/default.nix {
          pkgs = lua-shepi-nixpkgs.legacyPackages.${system};
        };
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
