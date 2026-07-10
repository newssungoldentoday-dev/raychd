#!/bin/bash
# ─────────────────────────────────────────
# Ray Chad — ddns-update.sh
# Auto-updates No-IP Dynamic DNS
# BlueBixt Developers © 2026
# ─────────────────────────────────────────

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
MUTED='\033[0;90m'
RESET='\033[0m'

echo ""
echo -e "${BOLD}${CYAN}  RAY CHAD IRC — Dynamic DNS Updater${RESET}"
echo -e "  BlueBixt Developers © 2026"
echo ""

# ── Configuration ──
HOSTNAME="raychad.ddns.net"
INTERVAL=3600

# ── Check curl ──
if ! command -v curl &>/dev/null; then
  echo -e "  ${YELLOW}curl not found. Installing...${RESET}"
  if [ -n "$TERMUX_VERSION" ]; then
    pkg install -y curl
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install curl
  else
    sudo apt install -y curl
  fi
fi

# ── Ask credentials interactively ──
echo -e "  ${YELLOW}Enter your No-IP credentials:${RESET}"
echo ""
read -p "  Email    : " newssungoldentoday@gmail.com
read -s -p "  Password : " DwF7esuVgN#!Agm
echo ""
echo ""

if [ -z "$NOIP_EMAIL" ] || [ -z "$NOIP_PASSWORD" ]; then
  echo -e "  ${RED}✘ Email and password cannot be empty.${RESET}"
  exit 1
fi

# ── Get current public IP ──
get_ip() {
  curl -s https://api.ipify.org
}

# ── Update No-IP DNS ──
update_dns() {
  CURRENT_IP=$(get_ip)

  if [ -z "$CURRENT_IP" ]; then
    echo -e "  ${RED}✘ Could not get public IP. Check your internet.${RESET}"
    return 1
  fi

  echo -e "  ${CYAN}Current IP:${RESET} $CURRENT_IP"
  echo -e "  ${YELLOW}Updating $HOSTNAME...${RESET}"

  RESPONSE=$(curl -s -u "$NOIP_EMAIL:$NOIP_PASSWORD" \
    "https://dynupdate.no-ip.com/nic/update?hostname=$HOSTNAME&myip=$CURRENT_IP")

  echo -e "  ${CYAN}Response:${RESET} $RESPONSE"

  if echo "$RESPONSE" | grep -q "good\|nochg"; then
    echo -e "  ${GREEN}${BOLD}✔ DNS updated successfully!${RESET}"
    echo -e "  ${CYAN}$HOSTNAME${RESET} → ${CYAN}$CURRENT_IP${RESET}"
  elif echo "$RESPONSE" | grep -q "nohost"; then
    echo -e "  ${RED}✘ Hostname not found. Check your No-IP hostname.${RESET}"
  elif echo "$RESPONSE" | grep -q "badauth"; then
    echo -e "  ${RED}✘ Wrong email or password. Please try again.${RESET}"
  elif echo "$RESPONSE" | grep -q "abuse"; then
    echo -e "  ${RED}✘ Account blocked. Contact No-IP support.${RESET}"
  else
    echo -e "  ${RED}✘ Unknown response: $RESPONSE${RESET}"
  fi
}

# ── Mode selection ──
echo -e "  ${YELLOW}Mode:${RESET}"
echo -e "  ${CYAN}1${RESET} — Update once now"
echo -e "  ${CYAN}2${RESET} — Auto-update every hour"
echo ""
read -p "  Choose [1/2]: " MODE

echo ""

if [ "$MODE" == "2" ]; then
  echo -e "  ${GREEN}Auto-update mode started. Press Ctrl+C to stop.${RESET}"
  echo ""
  while true; do
    update_dns
    echo ""
    echo -e "  ${MUTED}Next update in 1 hour...${RESET}"
    echo ""
    sleep $INTERVAL
  done
else
  update_dns
fi

echo ""
