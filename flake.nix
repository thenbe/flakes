{
  description = "thenbe's flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    lua-shepi-nixpkgs.url = "github:thenbe/nixpkgs/lua-shepi-1.4.1"; # TODO: only for lua-shepi
    aider.url = "path:./aider";
    crawley.url = "path:./crawley";
    dt.url = "path:./dt";
    tableplus.url = "path:./tableplus";
    playwright.url = "path:./playwright";
  };

  outputs = { self, nixpkgs, flake-utils, lua-shepi-nixpkgs, aider, crawley, dt, tableplus, playwright }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        brotab-modi = pkgs.callPackage ./brotab/default.nix {
          pkgs = lua-shepi-nixpkgs.legacyPackages.${system};
        };
      in
      {
        packages = {
          # default =
          aider = aider.outputs.packages.${system}.default;
          crawley = crawley.outputs.packages.${system}.default;
          dt = dt.outputs.packages.${system}.default;
          tableplus = tableplus.outputs.packages.${system}.default;
          playwright-driver = playwright.outputs.packages.${system}.playwright-driver;
          inherit brotab-modi;
        };

        apps = {
          brotab-modi = { program = "${brotab-modi}/bin/brotab-modi.lua"; type = "app"; };
        };

        devShells = {
          aider = aider.outputs.devShells.${system}.default;
          playwright-driver = playwright.outputs.devShells.${system}.default;
        };

        # flakes = { };
      }
    );
}
