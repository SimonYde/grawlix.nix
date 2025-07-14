{
  pkgs,
  lib,
  grawlix,
}:
let
  inherit (lib) concatStringsSep substring;

  mkDate =
    longDate:
    (concatStringsSep "-" [
      (substring 0 4 longDate)
      (substring 4 2 longDate)
      (substring 6 2 longDate)
    ]);

  date = mkDate (grawlix.lastModifiedDate or "19700101");
in
pkgs.python3Packages.buildPythonApplication {
  pname = "grawlix";
  version = "${date}_${grawlix.shortRev or "dirty"}";

  src = grawlix;

  pyproject = true;

  build-system = with pkgs.python3Packages; [
    setuptools
    setuptools-scm
  ];

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

      pyproject = true;

      build-system = with pkgs.python3Packages; [
        setuptools
        setuptools-scm
      ];

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
