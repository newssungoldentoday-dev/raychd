{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-pandadock";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/pandadock $out/bin
    echo "PANDADOCK_ENABLED=true" > $out/etc/raychd/envs/pandadock/.env
    echo "PANDADOCK_VERSION=1.0.0" >> $out/etc/raychd/envs/pandadock/.env
    echo "PANDADOCK_DOCKER_MODE=true" >> $out/etc/raychd/envs/pandadock/.env
  '';
  meta = with lib; { description = "Container dock environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
