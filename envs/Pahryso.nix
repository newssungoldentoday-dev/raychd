{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-pahryso";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/pahryso $out/bin
    echo "PAHRYSO_ENABLED=true" > $out/etc/raychd/envs/pahryso/.env
    echo "PAHRYSO_VERSION=1.0.0" >> $out/etc/raychd/envs/pahryso/.env
    echo "PAHRYSO_BASE_PATH=~/.raychd" >> $out/etc/raychd/envs/pahryso/.env
  '';
  meta = with lib; { description = "Path resolver environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
