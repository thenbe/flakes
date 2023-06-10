{
  description = "Playwright with Chromium";

  inputs = {
    nixpkgs.url = "github:thenbe/nixpkgs/playwright-driver-1.35.0";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        wrapped-playwright-driver = pkgs.runCommand "wrapped-playwright-driver" {buildInputs = [pkgs.makeWrapper];} ''
          mkdir -p "$out/bin"
          makeWrapper "${pkgs.playwright-driver}/bin/playwright" "$out/bin/playwright" \
            --set PLAYWRIGHT_BROWSERS_PATH "${pkgs.playwright-driver.browsers}" \
            --set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1 \
        '';

        playwright-driver-config = {
          environment.systemPackages = [
            wrapped-playwright-driver
          ];

          environment.variables = {
            PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
            PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
          };
        };
      in {
        packages = {
          playwright-driver = wrapped-playwright-driver;
          # default = wrapped-playwright-driver;
        };

        # export config for nixOS (includes package and sets env vars)
        nixosModules.playwright-driver = _: playwright-driver-config;
      }
    );
}
