{
  description = "thenbe's flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    aider.url = "path:./aider";
    crawley.url = "path:./crawley";
    dt.url = "path:./dt";
    tableplus.url = "path:./tableplus";
    playwright.url = "path:./playwright";
    brotab.url = "path:./brotab";
  };

  outputs = inputs@{ flake-parts, aider, crawley, dt, tableplus, playwright, brotab, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        # packages.default = pkgs.hello;
        packages = {
          # default =
          aider = aider.outputs.packages.${system}.default;
          crawley = crawley.outputs.packages.${system}.default;
          dt = dt.outputs.packages.${system}.default;
          tableplus = tableplus.outputs.packages.${system}.default;
          playwright-driver = playwright.outputs.packages.${system}.playwright-driver;
          brotab-modi = brotab.outputs.packages.${system}.brotab-modi;
        };
        apps = {
          brotab-modi = brotab.outputs.apps.${system}.brotab-modi;
        };
        devShells = {
          aider = aider.outputs.devShells.${system}.default;
          playwright-driver = playwright.outputs.devShells.${system}.default;
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
