# ============================================================================
# Ray Chad — ReFresh Environment
# Nix Package Definition
# BlueBixt Developers © 2026
# ============================================================================

{ lib
, stdenv
, fetchurl
, bash
, curl
}:

stdenv.mkDerivation rec {
  pname   = "raychd-env-refresh";
  version = "1.0.0";

  src = fetchurl {
    url    = "https://github.com/newssungoldentoday-dev/raychd/archive/refs/heads/main.tar.gz";
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [ bash curl ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/etc/raychd/envs/refresh
    mkdir -p $out/bin

    cat > $out/etc/raychd/envs/refresh/.env << EOF
# Ray Chad — ReFresh Environment Config
REFRESH_ENABLED=true
REFRESH_VERSION=1.0.0
REFRESH_INTERVAL=3600
REFRESH_ENV=production
EOF

    cat > $out/bin/raychd-env-refresh << EOF
#!/usr/bin/env bash
source $out/etc/raychd/envs/refresh/.env
echo "ReFresh environment activated."
EOF
    chmod +x $out/bin/raychd-env-refresh
  '';

  meta = with lib; {
    description = "Cache refresh environment for Ray Chad";
    homepage    = "https://github.com/newssungoldentoday-dev/raychd";
    license     = licenses.asl20;
    maintainers = [{ name = "BlueBixt Developers"; github = "newssungoldentoday-dev"; }];
    platforms   = platforms.unix;
    mainProgram = "raychd-env-refresh";
  };
}
