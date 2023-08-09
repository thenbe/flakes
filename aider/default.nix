{ pkgs }:
pkgs.python3Packages.buildPythonPackage rec {
  pname = "aider";
  version = "0.10.1";

  src = pkgs.fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "v${version}";
    hash = "sha256-I9iD3BU4wPTCW4A1sD493gcGNQ44aMI9XYTc9MYGMXI=";
  };

  # BUG: not taking effect, use sed in postPatch instead
  # nativeBuildInputs = with pkgs.python3Packages; [ pythonRelaxDepsHook ];
  # pythonRelaxDeps = true;
  postPatch = ''
    # use sed to remove all version numbers from requirements.txt
    sed -i 's/==.*//g' requirements.txt
  '';

  # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md#handling-dependencies-handling-dependencies
  propagatedBuildInputs = with pkgs.python3Packages; [
    pythonRelaxDepsHook
    aiosignal
    async-timeout
    attrs
    certifi
    charset-normalizer
    frozenlist
    gitdb
    GitPython
    idna
    markdown-it-py
    mdurl
    multidict
    openai
    prompt-toolkit
    pygments
    requests
    rich
    smmap
    tqdm
    urllib3
    wcwidth
    yarl
    pytest
    tiktoken
    configargparse
    pyyaml
    backoff
    networkx
    diskcache
    numpy
    scipy
    jsonschema
  ];

  doCheck = false; # tries to make network requests

  meta = with pkgs.lib; {
    description = "aider is GPT powered coding in your terminal";
    homepage = "https://github.com/paul-gauthier/aider";
    license = licenses.asl20;
    mainProgram = "aider";
    changelog = "https://github.com/paul-gauthier/aider/blob/main/HISTORY.md#${version}";
  };
}
