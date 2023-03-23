{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python3
, colorama
, boto3
, pluggy
, pyyaml
, psutil
}:

buildPythonPackage rec {
  pname = "awsume";
  version = "4.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "trek10inc";
    repo = "awsume";
    rev = "refs/tags/${version}";
    hash = "sha256-An7omHk2Yxjc6db6Y8QSrtgUvSF5rlVhgxMTpNOePHo=";
  };

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  propagatedBuildInputs = [
    psutil
    boto3
    colorama
    pyyaml
    pluggy
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest
    pytest-cov
  ];

  preCheck = ''
    substituteInPlace pytest.ini \
      --replace "python_paths" "pythonpath"
  '';

  checkPhase = ''
    pytest test/unit/awsume/awsumepy
  '';

  meta = with lib; {
    changelog = "https://github.com/trek10inc/awsume/releases/tag/${version}";
    description = "AWS assume made awesome";
    homepage = "https://awsu.me";
    license = licenses.mit;
    maintainers = with maintainers; [ pab ];
  };
}
