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
        katana = pkgs.callPackage ./katana/default.nix { };
      in
      {
        packages = {
          inherit aider;
          inherit brotab-modi;
          inherit crawley;
          inherit katana;
          dt = dt.outputs.packages.${system}.default;
          tableplus = tableplus.outputs.packages.${system}.default;
        };

        apps = {
          brotab-modi = { program = "${brotab-modi}/bin/brotab-modi.lua"; type = "app"; };
        };

        devShells = {
          aider = pkgs.mkShell { packages = [ aider pkgs.universal-ctags ]; };
          ollama-dev = pkgs.mkShell {
            packages = with pkgs; [
              cmake
              cudaPackages_12_2.cudatoolkit
              cudaPackages_12_2.cuda_nvcc
            ];
            shellHook = ''
              export CUDA_VERSION=$(${pkgs.cudaPackages_12_2.cuda_nvcc}/bin/nvcc --version | ${pkgs.gnused}/bin/sed -n 's/^.*release \([0-9]\+\)\.\([0-9]\+\).*$/\1/p')
            '';
          };
        };

        # flakes = { };
      }
    );
}
