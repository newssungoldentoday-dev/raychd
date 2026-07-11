{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-panda";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/panda $out/bin
    echo "PANDA_ENABLED=true" > $out/etc/raychd/envs/panda/.env
    echo "PANDA_VERSION=1.0.0" >> $out/etc/raychd/envs/panda/.env
    echo "PANDA_AUTO_UPDATE=false" >> $out/etc/raychd/envs/panda/.env
  '';
  meta = with lib; { description = "Package handler environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
