{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-libna";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/libna $out/bin
    echo "LIBNA_ENABLED=true" > $out/etc/raychd/envs/libna/.env
    echo "LIBNA_VERSION=1.0.0" >> $out/etc/raychd/envs/libna/.env
    echo "LIBNA_LIB_PATH=~/.raychd/lib" >> $out/etc/raychd/envs/libna/.env
  '';
  meta = with lib; { description = "Library navigator environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
