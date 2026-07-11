{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-reogu";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/reogu $out/bin
    echo "REOGU_ENABLED=true" > $out/etc/raychd/envs/reogu/.env
    echo "REOGU_VERSION=1.0.0" >> $out/etc/raychd/envs/reogu/.env
    echo "REOGU_LOG_LEVEL=info" >> $out/etc/raychd/envs/reogu/.env
  '';
  meta = with lib; { description = "Output guard environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
