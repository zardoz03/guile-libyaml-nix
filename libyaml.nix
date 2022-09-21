{ lib
, stdenv
, guile
, libyaml
, guile-nyacc
, scheme-bytestructures
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "guile-libyaml";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "mwette";
    repo = "guile-libyaml";
    rev = "2bdacb72a65ab63264b2edc9dac9692df7ec9b3e";
    sha256 = "8SCthUVwSKlsCcyTpruXHD6R+xgLxZ0FpXKHmINfWq8=";
  };

  nativeBuildInputs = [
    guile
    guile-nyacc
  ];
  buildInputs = [
    guile
    guile-nyacc
    libyaml
    scheme-bytestructures
  ];
  propagatedBuildInputs = [
    guile
    guile-nyacc
    scheme-bytestructures
  ];
  outputs = [ "out" ];

  sourceRoot = ".";

  unpackPhase = ''
    rm ./guix.scm \
       ./demo1.yml \
       ./demo1.scm \
       ./yaml/libyaml.scm \
       ./yaml/ffi-help-rt.scm
    cp "${guile-nyacc}"/share/guile/site/3.0/system/ffi-help-rt.scm \
       yaml/ffi-help-rt.scm
    sed -i 's#system ffi-help-rt#yaml ffi-help-rt#' yaml/ffi-help-rt.scm
  '';

  ##equiv to add-before buildPhase
  postConfigure = ''
    guild compile-ffi --no-exec yaml/libyaml.ffi
    sed -i 's#system ffi-help-rt#yaml ffi-help-rt#' \
        -i 's#dynamic-link "libyaml"#dynamic-link "${libyaml}"/lib/libyaml"#'
        yaml/libyaml.scm
  '';

  meta = with lib; {
    description = "Guile wrapper for libYAML";
    homepage = "https://github.com/mwette/guile-libyaml";
    ##this is a port of guix.scm from mwette/guile-libyaml
    license = licenses.lgpl3Plus;
    broken = !(versionOlder "2.0.13" guile.version);
    #taken from ./nyacc.nix
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
