{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-labera";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/labera $out/bin
    echo "LABERA_ENABLED=true" > $out/etc/raychd/envs/labera/.env
    echo "LABERA_VERSION=1.0.0" >> $out/etc/raychd/envs/labera/.env
    echo "LABERA_ERROR_LOG=~/.raychd/logs/errors.log" >> $out/etc/raychd/envs/labera/.env
  '';
  meta = with lib; { description = "Error reporter environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
