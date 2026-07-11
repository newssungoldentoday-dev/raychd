{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-envitorch";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/envitorch $out/bin
    echo "ENVITORCH_ENABLED=true" > $out/etc/raychd/envs/envitorch/.env
    echo "ENVITORCH_VERSION=1.0.0" >> $out/etc/raychd/envs/envitorch/.env
    echo "ENVITORCH_CORE_VERSION=1.0.0" >> $out/etc/raychd/envs/envitorch/.env
  '';
  meta = with lib; { description = "Environment torch core for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
