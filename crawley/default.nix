{ pkgs }:
pkgs.buildGo121Module rec {
  pname = "crawley";
  version = "1.6.14";

  src = pkgs.fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-XnDo0rC8sdjGDFPS6WIQucpl9m7SPnAc4SPHtn01Vqk=";
  };

  vendorSha256 = "sha256-cbrXYf+s94ZKwlR44+J5oufPWPUC6yOhl6K19q0bun8=";
  subPackages = [ "cmd/crawley" ];

  meta = {
    description = " The unix-way web crawler ";
    homepage = "https://github.com/s0rg/crawley";
    license = pkgs.lib.licenses.mit;
    mainProgram = "crawley";
  };
}
