{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-labrs";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/labrs $out/bin
    echo "LABRS_ENABLED=true" > $out/etc/raychd/envs/labrs/.env
    echo "LABRS_VERSION=1.0.0" >> $out/etc/raychd/envs/labrs/.env
    echo "LABRS_RUNTIME=bash" >> $out/etc/raychd/envs/labrs/.env
  '';
  meta = with lib; { description = "Lab runtime service environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
