{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-domino";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/domino $out/bin
    echo "DOMINO_ENABLED=true" > $out/etc/raychd/envs/domino/.env
    echo "DOMINO_VERSION=1.0.0" >> $out/etc/raychd/envs/domino/.env
    echo "DOMINO_DAEMON_MODE=true" >> $out/etc/raychd/envs/domino/.env
  '';
  meta = with lib; { description = "Daemon controller environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
