{ lib
, stdenv
, guile
  #, makeWrapper
  #, writeText
, scheme-bytestructures
,
}:
stdenv.mkDerivation rec {
  pname = "guile-nyacc";
  version = "1.07.0";

  src = builtins.fetchGit {
    url = "https://git.savannah.gnu.org/git/nyacc.git#main";
    rev = "cce9a943456b6b2b4cdd2d382e43fa0f78b5c4dd";
    allRefs = true;
  };

  nativeBuildInputs = [
    guile
  ];
  buildInputs = [
    guile
    scheme-bytestructures
  ];
  propagatedBuildInputs = [
    guile
    scheme-bytestructures
  ];
  outputs = [ "out" ];

  ###FIXME:
  #  postInstall =
  #    let
  #      versionList = builtins.split "\\." guile.version;
  #      # 1.2.3 => 1 "" 2 "" 3
  #      # i have no idea why they are empty strings
  #      versionWithoutPatch = "${lib.elemAt versionList 0}.${lib.elemAt versionList 2}";
  #      out = builtins.placeholder "out";
  #    in
  #    writeText "${out}/nyacc-load-location.scm"
  #      ''
  #        (add-to-load-path "${out}/share/guile/site/")
  #        (let ((file "${out}/lib/guile/${versionWithoutPatch}/site-ccache/"))
  #          (and (file-exists? file)
  #               (set! %load-compiled-path
  #                     (append file
  #                             %load-compiled-path))))
  #      '';

  meta = with lib; {
    description = "Parser-Generator of C code accessed through Guile";
    homepage = "https://www.nongnu.org/nyacc/";
    license = licenses.lgpl3;
    broken = !(versionOlder "2.0.13" guile.version);
    ## broken = guile.version < 2.0.13
    ## https://git.savannah.nongnu.org/cgit/nyacc.git/tree/INSTALL#n10
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
