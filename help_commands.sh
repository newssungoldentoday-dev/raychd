#!/usr/bin/env bash
#
# help-commands.sh — Ray Chad Forum / Ray Chad IRC
#
# One place to look up every command across the toolset instead of
# opening INSTALL.sh, getphorus.sh, package.json, etc. individually.
#
# Usage:
#   bash help-commands.sh                # show everything
#   bash help-commands.sh <section>      # show one section
#   bash help-commands.sh search <term>  # grep across all commands
#
# Sections: install, getphorus, npm, docker, static, forum, all

set -uo pipefail

if [ -t 1 ]; then
  GREEN="\033[0;32m"; AMBER="\033[0;33m"; DIM="\033[2m"; BOLD="\033[1m"; RESET="\033[0m"
else
  GREEN=""; AMBER=""; DIM=""; BOLD=""; RESET=""
fi

heading() { printf "\n${BOLD}${GREEN}// %s${RESET}\n" "$1"; }
cmd()     { printf "  ${GREEN}\$${RESET} %-46s ${DIM}%s${RESET}\n" "$1" "$2"; }
note()    { printf "  ${AMBER}!${RESET} %s\n" "$1"; }

# ---------------------------------------------------------------------------
# Section: INSTALL.sh
# ---------------------------------------------------------------------------
section_install() {
  heading "INSTALL.sh — setup"
  cmd "bash INSTALL.sh"                 "auto-detect platform, install + start"
  cmd "bash INSTALL.sh --docker"        "force Docker Compose install"
  cmd "bash INSTALL.sh --manual"        "force manual Node.js install (used automatically on Termux)"
  cmd "bash INSTALL.sh --help"          "show INSTALL.sh's own usage"
  sleep 1
}

# ---------------------------------------------------------------------------
# Section: getphorus.sh
# ---------------------------------------------------------------------------
section_getphorus() {
  heading "getphorus.sh — public IP helper (Ray Chad IRC)"
  cmd "bash getphorus.sh self"                 "print this machine's public IP"
  cmd "bash getphorus.sh self --update-env"    "also write RAYCHD_PUBLIC_IP to .env"
  cmd "bash getphorus.sh lookup <ip>"          "geolocation/ISP info for an IP (moderation)"
  cmd "bash getphorus.sh lookup me"            "geolocation/ISP info for your own IP"
  cmd "bash getphorus.sh connect"              "print a ready-to-copy /connect command"
  note "lookup uses ip-api.com (free tier, HTTP only) — see script header for privacy notes"
  sleep 1
}

# ---------------------------------------------------------------------------
# Section: npm (package.json scripts)
# ---------------------------------------------------------------------------
section_npm() {
  heading "npm scripts — Node.js forum backend"
  cmd "npm install"              "install dependencies"
  cmd "npm start"                "run the forum server (server.js)"
  cmd "npm run dev"              "run with --watch for auto-restart"
  cmd "npm run migrate"          "run database migrations (scripts/migrate.js)"
  cmd "npm run seed"             "seed initial boards/data (scripts/seed.js)"
  cmd "npm run bridge:enable"    "turn on the IRC bridge bot"
  cmd "npm run bridge:disable"   "turn off the IRC bridge bot"
  cmd "npm test"                 "run tests"
  cmd "npm run lint"             "run eslint"
  sleep 1
}

# ---------------------------------------------------------------------------
# Section: docker-compose.yml
# ---------------------------------------------------------------------------
section_docker() {
  heading "docker-compose — containerized forum"
  cmd "docker compose up -d"        "build and start the forum container"
  cmd "docker compose ps"           "check container status/health"
  cmd "docker compose logs -f"      "tail container logs"
  cmd "docker compose down"        "stop and remove containers"
  cmd "docker compose down -v"      "also remove the forum-data volume (destroys DB)"
  note "set RAYCHD_NETWORK_NAME / RAYCHD_NETWORK_EXTERNAL in .env to bridge with an existing raychd stack"
  sleep 1
}

# ---------------------------------------------------------------------------
# Section: server.cpp (static file server)
# ---------------------------------------------------------------------------
section_static() {
  heading "server.cpp — static file server"
  cmd "g++ -std=c++17 -O2 -pthread server.cpp -o raychd-forum-server" "build it"
  cmd "./raychd-forum-server"                    "run on port 8080, cwd as webroot"
  cmd "./raychd-forum-server 3000"               "run on a custom port"
  cmd "PORT=3000 WEBROOT=./dist ./raychd-forum-server" "custom port + webroot via env vars"
  note "static assets only — no boards/threads logic, see base.local for the full storage breakdown"
  sleep 1
}

# ---------------------------------------------------------------------------
# Section: raychd command wrapper (bashrc/zshrc shortcut)
# ---------------------------------------------------------------------------
section_raychd() {
  heading "raychd — IRC server shortcut (from ~/.bashrc or ~/.zshrc)"
  echo "  raychd start       🚀 Starting Ray Chad IRC Server..."
  echo "  raychd stop        ⏹️  Stopping Ray Chad IRC Server..."
  echo "  raychd restart     🔄 Restarting Ray Chad IRC Server..."
  echo "  raychd status      📊 Ray Chad Server Status..."
  echo "  raychd logs        📋 Ray Chad Server Logs (Ctrl+C to exit)..."
  echo "  raychd edit        ✏️  Opening configuration file..."
  echo "  raychd config      📄 Configuration file location..."
  echo "  raychd info        ℹ️  Ray Chad IRC Server Information..."
  echo "  raychd connect     💬 Connection Information..."
  echo "  raychd help        Show raychd's own usage"
  note "shows local/LAN connection info via hostname -I — for your public IP use: bash getphorus.sh self"
  sleep 1
}

# ---------------------------------------------------------------------------
# Section: forum.php actions (URL query params, not shell commands)
# ---------------------------------------------------------------------------
section_forum() {
  heading "forum.php — page actions (visit in a browser, not the shell)"
  cmd "forum.php"                             "board list (home page)"
  cmd "forum.php?action=login"                "log in (username only, demo auth)"
  cmd "forum.php?action=board&slug=<slug>"    "view a board's threads"
  cmd "forum.php?action=thread&id=<id>"       "view a thread + replies"
  cmd "php -S 0.0.0.0:8080 forum.php"         "run forum.php with PHP's built-in dev server"
  note "forum.php's login is a placeholder (no password) — don't expose it publicly as-is"
  sleep 1
}

# ---------------------------------------------------------------------------
# search
# ---------------------------------------------------------------------------
do_search() {
  local term="$1"
  local hits=0
  for section in install getphorus raychd npm docker static forum; do
    local out
    out="$("section_$section" 2>/dev/null | grep -i --color=never "$term" || true)"
    if [ -n "$out" ]; then
      heading "matches in: $section"
      echo "$out"
      hits=1
    fi
  done
  if [ "$hits" -eq 0 ]; then
    echo "No commands matched \"$term\"."
  fi
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
TARGET="${1:-all}"

case "$TARGET" in
  install)   section_install ;;
  getphorus) section_getphorus ;;
  raychd)    section_raychd ;;
  npm)       section_npm ;;
  docker)    section_docker ;;
  static)    section_static ;;
  forum)     section_forum ;;
  search)
    if [ -z "${2:-}" ]; then
      echo "usage: bash help-commands.sh search <term>"
      exit 1
    fi
    do_search "$2"
    ;;
  all|"")
    section_install
    section_getphorus
    section_raychd
    section_npm
    section_docker
    section_static
    section_forum
    echo
    ;;
  -h|--help)
    cat <<EOF
help-commands.sh — command reference for Ray Chad Forum / Ray Chad IRC

Usage:
  bash help-commands.sh                # show all sections
  bash help-commands.sh <section>      # show one section
  bash help-commands.sh search <term>  # grep across all commands

Sections: install, getphorus, raychd, npm, docker, static, forum
EOF
    ;;
  *)
    echo "Unknown section: $TARGET"
    echo "Run 'bash help-commands.sh --help' for usage."
    exit 1
    ;;
esac




