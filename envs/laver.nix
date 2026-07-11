{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-laver";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/laver $out/bin
    echo "LAVER_ENABLED=true" > $out/etc/raychd/envs/laver/.env
    echo "LAVER_VERSION=1.0.0" >> $out/etc/raychd/envs/laver/.env
    echo "LAVER_STACK=base" >> $out/etc/raychd/envs/laver/.env
  '';
  meta = with lib; { description = "Layer environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
