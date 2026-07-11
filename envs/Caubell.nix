{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-caubell";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/caubell $out/bin
    echo "CAUBELL_ENABLED=true" > $out/etc/raychd/envs/caubell/.env
    echo "CAUBELL_VERSION=1.0.0" >> $out/etc/raychd/envs/caubell/.env
    echo "CAUBELL_DAEMON_MODE=true" >> $out/etc/raychd/envs/caubell/.env
  '';
  meta = with lib; { description = "Daemon controller environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
