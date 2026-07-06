#!/usr/bin/env bash
#
# getphorus.sh — Getphorus (PhorusMach) for Ray Chad IRC
#
# Uses a public IP API for two things:
#   1. "self"   — detect this machine's public IP, optionally write it
#                 into .env as RAYCHD_PUBLIC_IP.
#   2. "lookup" — look up a connecting user's rough geolocation and
#                 ISP info, for moderation context (e.g. spotting
#                 ban-evasion from the same region/ISP).
#
# Bonus:
#   "connect"   — prints a ready-to-copy /connect command using your
#                 own detected IP or configured hostname, matching the
#                 banner in your-ip-banner.html.
#
# APIs used (both free, no API key required):
#   - https://api.ipify.org           → your own public IP
#   - http://ip-api.com/json/<ip>     → geolocation + ISP for any IP
#     (ip-api.com's free tier is HTTP-only; see NOTES below)
#
# Usage:
#   bash getphorus.sh self                 # print this machine's public IP
#   bash getphorus.sh self --update-env    # also write it into .env
#   bash getphorus.sh lookup <ip>          # geolocation info for an IP
#   bash getphorus.sh lookup me            # geolocation info for your own IP
#   bash getphorus.sh connect              # print a /connect command
#
# NOTES / privacy:
#   - ip-api.com's free endpoint is plain HTTP, not HTTPS. Don't run
#     lookups over an untrusted network, and don't pipe sensitive data
#     through it beyond the bare IP.
#   - Free tier is rate-limited (45 requests/minute per source IP).
#     For production moderation tooling, use a paid/HTTPS provider.
#   - Logging or displaying a user's geolocation is personal data under
#     RA 10173 (Philippine Data Privacy Act). Keep lookups tied to an
#     actual moderation need, don't log more than necessary, and cover
#     this in your privacy policy if you store lookup results.

set -uo pipefail

IPIFY_URL="https://api.ipify.org?format=json"
IPAPI_BASE="http://ip-api.com/json"
ENV_FILE=".env"
IRC_PORT="${RAYCHD_IRC_PORT:-6697}"

if [ -t 1 ]; then
  GREEN="\033[0;32m"; AMBER="\033[0;33m"; RED="\033[0;31m"; DIM="\033[2m"; RESET="\033[0m"
else
  GREEN=""; AMBER=""; RED=""; DIM=""; RESET=""
fi
log()  { printf "${GREEN}[phorus]${RESET} %s\n" "$1"; }
warn() { printf "${AMBER}[phorus]${RESET} %s\n" "$1"; }
err()  { printf "${RED}[phorus]${RESET} %s\n" "$1" >&2; }

require_curl() {
  if ! command -v curl >/dev/null 2>&1; then
    err "curl is required but not found."
    err "Termux: pkg install curl   |   Debian/Ubuntu: sudo apt install curl"
    exit 1
  fi
}

# Minimal JSON field extractor so this works without jq installed.
json_field() {
  local key="$1" json="$2"
  echo "$json" | grep -o "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -n1 | sed -E "s/\"$key\"[[:space:]]*:[[:space:]]*\"([^\"]*)\"/\1/"
}

# ---------------------------------------------------------------------------
# self: detect this machine's public IP
# ---------------------------------------------------------------------------
cmd_self() {
  require_curl
  log "querying ipify for public IP..."
  local resp
  resp="$(curl -fsS --max-time 8 "$IPIFY_URL")" || { err "ipify request failed (network issue or offline)"; exit 1; }

  local ip
  if command -v jq >/dev/null 2>&1; then
    ip="$(echo "$resp" | jq -r '.ip')"
  else
    ip="$(json_field "ip" "$resp")"
  fi

  if [ -z "$ip" ]; then
    err "could not parse IP from response: $resp"
    exit 1
  fi

  log "public IP: $ip"

  if [ "${1:-}" = "--update-env" ]; then
    if [ ! -f "$ENV_FILE" ]; then
      warn "$ENV_FILE not found — creating it"
      touch "$ENV_FILE"
    fi
    if grep -q '^RAYCHD_PUBLIC_IP=' "$ENV_FILE" 2>/dev/null; then
      sed -i.bak "s/^RAYCHD_PUBLIC_IP=.*/RAYCHD_PUBLIC_IP=$ip/" "$ENV_FILE"
    else
      echo "RAYCHD_PUBLIC_IP=$ip" >> "$ENV_FILE"
    fi
    log "wrote RAYCHD_PUBLIC_IP=$ip to $ENV_FILE"
    warn "RAYCHD_DOMAIN was left untouched — set that manually if you're using a real domain instead of a bare IP."
  fi
}

# ---------------------------------------------------------------------------
# lookup: geolocation + ISP for a given IP (moderation use)
# ---------------------------------------------------------------------------
cmd_lookup() {
  require_curl
  local target="${1:-}"
  if [ -z "$target" ]; then
    err "usage: bash getphorus.sh lookup <ip|me>"
    exit 1
  fi
  if [ "$target" = "me" ]; then
    target=""   # ip-api.com/json (no IP) returns info for the caller
  fi

  log "looking up ${target:-your own IP}..."
  local resp
  resp="$(curl -fsS --max-time 8 "$IPAPI_BASE/$target")" || { err "ip-api.com request failed (network issue or offline)"; exit 1; }

  local status
  if command -v jq >/dev/null 2>&1; then
    status="$(echo "$resp" | jq -r '.status')"
  else
    status="$(json_field "status" "$resp")"
  fi

  if [ "$status" != "success" ]; then
    err "lookup failed: $resp"
    exit 1
  fi

  if command -v jq >/dev/null 2>&1; then
    echo "$resp" | jq -r '
      "  IP:       \(.query)",
      "  Location: \(.city), \(.regionName), \(.country)",
      "  ISP:      \(.isp)",
      "  Org:      \(.org)",
      "  Timezone: \(.timezone)"
    '
  else
    printf "  IP:       %s\n"  "$(json_field "query" "$resp")"
    printf "  Location: %s, %s, %s\n" "$(json_field "city" "$resp")" "$(json_field "regionName" "$resp")" "$(json_field "country" "$resp")"
    printf "  ISP:      %s\n"  "$(json_field "isp" "$resp")"
    printf "  Org:      %s\n"  "$(json_field "org" "$resp")"
    printf "  Timezone: %s\n"  "$(json_field "timezone" "$resp")"
  fi

  warn "Reminder: treat this as personal data under RA 10173 — only log what a real moderation case needs."
}

# ---------------------------------------------------------------------------
# connect: print a ready-to-copy /connect command using the detected
# public IP (or RAYCHD_DOMAIN from .env if set), matching the banner
# in your-ip-banner.html.
# ---------------------------------------------------------------------------
cmd_connect() {
  require_curl
  local host=""

  if [ -f "$ENV_FILE" ] && grep -q '^RAYCHD_DOMAIN=' "$ENV_FILE" 2>/dev/null; then
    host="$(grep '^RAYCHD_DOMAIN=' "$ENV_FILE" | head -n1 | cut -d= -f2-)"
  fi

  if [ -z "$host" ]; then
    log "no RAYCHD_DOMAIN in $ENV_FILE — detecting public IP instead"
    local resp
    resp="$(curl -fsS --max-time 8 "$IPIFY_URL")" || { err "ipify request failed"; exit 1; }
    if command -v jq >/dev/null 2>&1; then
      host="$(echo "$resp" | jq -r '.ip')"
    else
      host="$(json_field "ip" "$resp")"
    fi
  fi

  if [ -z "$host" ]; then
    err "could not determine a host to connect to"
    exit 1
  fi

  echo "/connect $host $IRC_PORT"
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  self)    cmd_self "$@" ;;
  lookup)  cmd_lookup "$@" ;;
  connect) cmd_connect ;;
  ""|help|-h|--help)
    cat <<EOF
Getphorus (PhorusMach) — public IP API helper for Ray Chad IRC

Usage:
  bash getphorus.sh self                 Print this machine's public IP
  bash getphorus.sh self --update-env    Also write RAYCHD_PUBLIC_IP to .env
  bash getphorus.sh lookup <ip>          Geolocation/ISP info for an IP
  bash getphorus.sh lookup me            Geolocation/ISP info for your own IP
  bash getphorus.sh connect              Print a ready-to-copy /connect command

Set RAYCHD_DOMAIN in .env to use a real hostname instead of a bare IP
for the 'connect' command. Set RAYCHD_IRC_PORT to override the default
port (6697).
EOF
    ;;
  *)
    err "unknown command: $COMMAND"
    err "run 'bash getphorus.sh help' for usage"
    exit 1
    ;;
esac
