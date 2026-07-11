{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-lifeder";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/lifeder $out/bin
    echo "LIFEDER_ENABLED=true" > $out/etc/raychd/envs/lifeder/.env
    echo "LIFEDER_VERSION=1.0.0" >> $out/etc/raychd/envs/lifeder/.env
    echo "LIFEDER_AUTO_RESTART=true" >> $out/etc/raychd/envs/lifeder/.env
  '';
  meta = with lib; { description = "Lifecycle manager environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
