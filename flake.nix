{
  description = "thenbe's flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    tableplus.url = "path:./tableplus";
  };

  outputs = { self, nixpkgs, flake-utils, tableplus }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        aider = pkgs.callPackage ./aider/default.nix { };
        brotab-modi = pkgs.callPackage ./brotab/default.nix { };
        crawley = pkgs.callPackage ./crawley/default.nix { };
        dt = pkgs.callPackage ./dt/default.nix { };
        katana = pkgs.callPackage ./katana/default.nix { };
      in
      {
        packages = {
          inherit aider;
          inherit brotab-modi;
          inherit crawley;
          inherit katana;
          inherit dt;
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
