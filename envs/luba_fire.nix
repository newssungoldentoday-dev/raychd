{ lib, stdenv, fetchurl, bash, curl }:
stdenv.mkDerivation rec {
  pname   = "raychd-env-lubafire";
  version = "1.0.0";
  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };
  nativeBuildInputs = [ bash curl ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/etc/raychd/envs/lubafire $out/bin
    echo "LUBAFIRE_ENABLED=true" > $out/etc/raychd/envs/lubafire/.env
    echo "LUBAFIRE_VERSION=1.0.0" >> $out/etc/raychd/envs/lubafire/.env
    echo "LUBAFIRE_FIREWALL=active" >> $out/etc/raychd/envs/lubafire/.env
    echo "LUBAFIRE_PORT=6667" >> $out/etc/raychd/envs/lubafire/.env
  '';
  meta = with lib; { description = "Firewall environment for Ray Chad"; homepage = "https://github.com/newssungoldentoday-dev/raychd"; license = licenses.asl20; platforms = platforms.unix; };
}
