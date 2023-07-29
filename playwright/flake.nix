{
  description = "Playwright with Chromium";
  inputs = {
    nixpkgs.url = "github:thenbe/nixpkgs/playwright-driver-1.35.0";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    wrapped-playwright-driver = nixpkgs.runCommand "wrapped-playwright-driver" {buildInputs = [nixpkgs.makeWrapper];} ''
      mkdir -p "$out/bin"
      makeWrapper "${nixpkgs.playwright-driver}/bin/playwright" "$out/bin/playwright" \
        --set PLAYWRIGHT_BROWSERS_PATH "${nixpkgs.playwright-driver.browsers}" \
        --set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1 \
    '';
  in {
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
  };
}
