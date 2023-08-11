{
  description = "Playwright with Chromium";
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:thenbe/nixpkgs/playwright-driver-1.37.0";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        wrapped-playwright-driver = pkgs.runCommand "wrapped-playwright-driver"
          { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
          mkdir -p "$out/bin"
          makeWrapper "${pkgs.playwright-driver}/bin/playwright" "$out/bin/playwright" \
            --set PLAYWRIGHT_BROWSERS_PATH "${pkgs.playwright-driver.browsers}" \
            --set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1 \
        '';
      in
      {
        packages = {
          playwright-driver = wrapped-playwright-driver;
        };
        # export config for nixOS (includes package and sets env vars)
        nixosModules.playwright-driver = _: {
          environment.systemPackages = [
            wrapped-playwright-driver
          ];
          environment.variables = {
            PLAYWRIGHT_BROWSERS_PATH = "${nixpkgs.playwright-driver.browsers}";
            PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
          };
        };
        # nix develop .#playwright-driver
        devShells = {
          default = pkgs.mkShell {
            packages = [
              wrapped-playwright-driver
            ];
            shellHook = ''
              export PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}"
              export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
            '';
          };
        };
      }
    );
}
