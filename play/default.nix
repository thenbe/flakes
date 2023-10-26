{ pkgs }:
pkgs.buildGo121Module rec {
  pname = "play";
  version = "00b82ac8803956c7efea8a3bf8f52dba6d54d645";

  src = pkgs.fetchFromGitHub {
    owner = "paololazzari";
    repo = "play";
    rev = "${version}";
    hash = "sha256-E2EQ5TWEggFA5iGBJGqxrfRLM+zNtG7NZX77ywW4iBg=";
  };

  vendorSha256 = "sha256-9eP0rhsgpTttYrBG/BNk/ICtaM+zKNBz2H2cHuTSt30=";

  meta = {
    description = "A TUI playground to experiment with your favorite programs, such as grep, sed, awk, jq and yq";
    homepage = "https://github.com/paololazzari/play";
    license = pkgs.lib.licenses.asl20;
    mainProgram = "play";
  };
}
