#!/usr/bin/env bash
#
# start.sh — Ray Chad IRC
#
# Starts the raychd InspIRCd server. Nothing else — the forum has its
# own startup paths (INSTALL.sh, docker-compose.yml, forum.php).
#
# Usage:
#   bash start.sh
#
# Set RAYCHD_HOME if raychd isn't installed at the default location
# ($HOME/raychd).

set -uo pipefail

if [ -t 1 ]; then
  GREEN="\033[0;32m"; AMBER="\033[0;33m"; RED="\033[0;31m"; RESET="\033[0m"
else
  GREEN=""; AMBER=""; RED=""; RESET=""
fi
log()  { printf "${GREEN}==>${RESET} %s\n" "$1"; }
warn() { printf "${AMBER}!!${RESET} %s\n" "$1"; }
err()  { printf "${RED}xx${RESET} %s\n" "$1" >&2; }

log "Starting Ray Chad IRC..."

if command -v raychd >/dev/null 2>&1; then
  raychd start
  exit $?
fi

INSPIRCD_BIN="${RAYCHD_HOME:-$HOME/raychd}/inspircd/bin/inspircd"

if [ -x "$INSPIRCD_BIN" ]; then
  "$INSPIRCD_BIN" start
  log "raychd IRC started via $INSPIRCD_BIN"
  exit 0
fi

err "Couldn't find the 'raychd' shell function or an inspircd binary at \$RAYCHD_HOME."
err "Either source your raychd.sh shortcut script (see ~/.bashrc/~/.zshrc), or set RAYCHD_HOME to your install directory and re-run."
exit 1
