{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-devenvi";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/devenvi $out/bin
    echo "DEVENVI_ENABLED=true" > $out/etc/raychd/envs/devenvi/.env
    echo "DEVENVI_VERSION=1.0.0" >> $out/etc/raychd/envs/devenvi/.env
    echo "DEVENVI_DEBUG=false" >> $out/etc/raychd/envs/devenvi/.env
  '';
  meta = with lib; { description = "Developer environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
