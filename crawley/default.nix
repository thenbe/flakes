{ pkgs }:
pkgs.buildGoModule rec {
  pname = "crawley";
  version = "1.6.8";

  src = pkgs.fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-PSWpqPCk/qJrP79dWGkipSgQerD5Y9jIWdXAKy33zO8=";
  };

  vendorSha256 = "sha256-W3pXmrHhZDGjqA0K/3ohdgUZKOClh4qNC3chZKums2k=";
  subPackages = [ "cmd/crawley" ];

  meta = {
    description = " The unix-way web crawler ";
    homepage = "https://github.com/s0rg/crawley";
    license = pkgs.lib.licenses.mit;
    mainProgram = "crawley";
  };
}
