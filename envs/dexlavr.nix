{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-dexlavr";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/dexlavr $out/bin
    echo "DEXLAVR_ENABLED=true" > $out/etc/raychd/envs/dexlavr/.env
    echo "DEXLAVR_VERSION=1.0.0" >> $out/etc/raychd/envs/dexlavr/.env
    echo "DEXLAVR_DEV_MODE=false" >> $out/etc/raychd/envs/dexlavr/.env
  '';
  meta = with lib; { description = "Dev extension layer environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
