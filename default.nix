{
  pkgs,
  lib,
  grawlix,
}:
pkgs.python3Packages.buildPythonApplication {
  pname = "grawlix";
  version = "2024-10-02";

  src = grawlix;

  propagatedBuildInputs = with pkgs.python3Packages; [
    appdirs
    beautifulsoup4
    importlib-resources
    lxml
    pycryptodome
    rich
    tomli
    httpx
    urllib3

    # Build
    setuptools
    ebooklib


    (buildPythonPackage rec {
      pname = "blackboxprotobuf";
      version = "1.0.1";

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-IztxTmwkzp0cILhxRioiCvkXfk/sAcG3l6xauGoeHOo=";
      };

      propagatedBuildInputs = [ protobuf ];

      patchPhase = ''
        substituteInPlace ./requirements.txt \
        --replace "protobuf==3.10.0" "protobuf"
      '';

      doCheck = false;
    })
  ];
  doCheck = false;

  meta = with lib; {
    description = "eBook cli downloader";
    homepage = "https://github.com/jo1gi/grawlix";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
