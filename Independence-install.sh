#!/bin/bash
# ============================================================================
# Ray Chad — independence-install.sh
# Installs Ray Chad independently without Docker
# Installs all dependencies separately
# BlueBixt Developers © 2026
# ============================================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
MUTED='\033[0;90m'
RESET='\033[0m'

VERSION="1.0.0"
REPO="https://github.com/newssungoldentoday-dev/raychd.git"
INSTALL_DIR="$HOME/.raychd"

# ── Dependencies List ──
DEPS_TERMUX=("inspircd" "git" "curl" "wget" "nano" "openssl" "irssi")
DEPS_LINUX=("inspircd" "git" "curl" "wget" "nano" "openssl" "irssi" "gcc" "make")
DEPS_MACOS=("inspircd" "git" "curl" "wget" "nano" "openssl" "irssi" "gcc")

TOTAL_STEPS=6
CURRENT_STEP=0

# ── Bounce Loader ──
bounce_loader() {
  local MESSAGE=$1
  local DURATION=$2
  local WIDTH=24
  local POS=0
  local DIR=1
  local END=$(($(date +%s) + DURATION))

  while [ $(date +%s) -lt $END ]; do
    BAR=""
    for ((i=0; i<WIDTH; i++)); do
      if [ $i -eq $POS ]; then BAR="${BAR}O"
      else BAR="${BAR}-"; fi
    done
    printf "\r  ${CYAN}[${BAR}]${RESET}  ${MESSAGE}"
    POS=$((POS + DIR))
    if [ $POS -ge $((WIDTH - 1)) ]; then DIR=-1; fi
    if [ $POS -le 0 ]; then DIR=1; fi
    sleep 0.07
  done

  DONE_BAR=""
  for ((i=0; i<WIDTH; i++)); do DONE_BAR="${DONE_BAR}─"; done
  printf "\r  ${GREEN}[${DONE_BAR}]${RESET}  ${GREEN}✔ ${MESSAGE}${RESET}\n"
}

# ── Step Counter ──
step() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  echo ""
  echo -e "  ${BOLD}${CYAN}[Step ${CURRENT_STEP}/${TOTAL_STEPS}]${RESET} $1"
  echo ""
}

# ── Detect OS ──
detect_os() {
  if [ -n "$TERMUX_VERSION" ]; then OS="termux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then OS="macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then OS="linux"
  else OS="unknown"; fi
}

# ── Install Single Dependency ──
install_dep() {
  local DEP=$1
  bounce_loader "Installing $DEP..." 1

  if [ "$OS" == "termux" ]; then
    pkg install -y "$DEP" &>/dev/null
  elif [ "$OS" == "macos" ]; then
    brew install "$DEP" &>/dev/null
  elif [ "$OS" == "linux" ]; then
    if command -v apt &>/dev/null; then
      sudo apt install -y "$DEP" &>/dev/null
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y "$DEP" &>/dev/null
    elif command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm "$DEP" &>/dev/null
    fi
  fi
}

# ── Step 1: Detect OS ──
clear
echo ""
echo -e "${BOLD}${CYAN}  ============================================================${RESET}"
echo -e "${BOLD}${CYAN}   Ray Chad — Independence Installer v${VERSION}${RESET}"
echo -e "${BOLD}${CYAN}  ============================================================${RESET}"
echo -e "  ${MUTED}BlueBixt Developers © 2026${RESET}"
echo -e "  ${MUTED}No Docker required — fully independent install${RESET}"
echo ""

read -p "  Proceed with installation? [y/N]: " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo -e "\n  ${YELLOW}Installation cancelled.${RESET}\n"
  exit 0
fi

step "Detecting operating system..."
detect_os
bounce_loader "Detecting OS..." 1
echo -e "  ${CYAN}Detected:${RESET} $OS"

# ── Step 2: Update package manager ──
step "Updating package manager..."
if [ "$OS" == "termux" ]; then
  bounce_loader "Updating pkg..." 2
  pkg update -y &>/dev/null
elif [ "$OS" == "macos" ]; then
  bounce_loader "Updating Homebrew..." 2
  brew update &>/dev/null
elif [ "$OS" == "linux" ]; then
  bounce_loader "Updating apt..." 2
  sudo apt update &>/dev/null
fi
echo -e "  ${GREEN}✔ Package manager updated.${RESET}"

# ── Step 3: Install dependencies separately ──
step "Installing dependencies independently..."

if [ "$OS" == "termux" ]; then
  DEPS=("${DEPS_TERMUX[@]}")
elif [ "$OS" == "macos" ]; then
  DEPS=("${DEPS_MACOS[@]}")
else
  DEPS=("${DEPS_LINUX[@]}")
fi

for DEP in "${DEPS[@]}"; do
  install_dep "$DEP"
done

echo ""
echo -e "  ${GREEN}✔ All dependencies installed independently.${RESET}"

# ── Step 4: Clone Ray Chad repo ──
step "Cloning Ray Chad repository..."
bounce_loader "Cloning from GitHub..." 2

if [ -d "$INSTALL_DIR/repo" ]; then
  echo -e "  ${YELLOW}Existing install found. Pulling latest...${RESET}"
  cd "$INSTALL_DIR/repo" && git pull &>/dev/null && cd ~
else
  mkdir -p "$INSTALL_DIR"
  git clone "$REPO" "$INSTALL_DIR/repo" &>/dev/null
fi

echo -e "  ${GREEN}✔ Repository cloned to $INSTALL_DIR/repo${RESET}"

# ── Step 5: Setup InspIRCd config ──
step "Setting up InspIRCd configuration..."
bounce_loader "Copying config files..." 1

mkdir -p "$INSTALL_DIR/config"

if [ -f "$INSTALL_DIR/repo/inspircd.conf" ]; then
  cp "$INSTALL_DIR/repo/inspircd.conf" "$INSTALL_DIR/config/inspircd.conf"
  echo -e "  ${GREEN}✔ Config copied to $INSTALL_DIR/config/inspircd.conf${RESET}"
else
  echo -e "  ${YELLOW}⚠ inspircd.conf not found. Using default.${RESET}"
fi

# Setup scripts
chmod +x "$INSTALL_DIR/repo/terminal-bash/"*.sh 2>/dev/null
echo -e "  ${GREEN}✔ Scripts made executable.${RESET}"

# ── Step 6: Create raychd command ──
step "Creating raychd global command..."
bounce_loader "Setting up raychd command..." 1

BIN_PATH="$HOME/.local/bin"
mkdir -p "$BIN_PATH"

cat > "$BIN_PATH/raychd" << CMDEOF
#!/bin/bash
# Ray Chad global command
RAYCHD_DIR="$INSTALL_DIR/repo"
CMD=\$1
case "\$CMD" in
  start)   bash "\$RAYCHD_DIR/terminal-bash/start.sh" ;;
  stop)    bash "\$RAYCHD_DIR/terminal-bash/stop.sh" ;;
  status)  bash "\$RAYCHD_DIR/terminal-bash/status.sh" ;;
  connect) bash "\$RAYCHD_DIR/terminal-bash/connect.sh" ;;
  ddns)    bash "\$RAYCHD_DIR/terminal-bash/ddns-update.sh" ;;
  install-env) bash "\$RAYCHD_DIR/environment-install.sh" ;;
  *)
    echo ""
    echo "  Ray Chad IRC v${VERSION}"
    echo "  Usage: raychd [command]"
    echo ""
    echo "  Commands:"
    echo "    start        Start IRC server"
    echo "    stop         Stop IRC server"
    echo "    status       Check server status"
    echo "    connect      Connect to IRC channel"
    echo "    ddns         Update Dynamic DNS"
    echo "    install-env  Install environments"
    echo ""
    ;;
esac
CMDEOF

chmod +x "$BIN_PATH/raychd"

# Add to PATH if not already
if [[ ":$PATH:" != *":$BIN_PATH:"* ]]; then
  echo "export PATH=\"$BIN_PATH:\$PATH\"" >> "$HOME/.bashrc"
  echo "export PATH=\"$BIN_PATH:\$PATH\"" >> "$HOME/.bash_profile"
  export PATH="$BIN_PATH:$PATH"
fi

echo -e "  ${GREEN}✔ raychd command created at $BIN_PATH/raychd${RESET}"

# ── Done ──
echo ""
echo -e "${BOLD}${CYAN}  ============================================================${RESET}"
echo -e "  ${GREEN}${BOLD}✔ Ray Chad installed independently!${RESET}"
echo -e "${BOLD}${CYAN}  ============================================================${RESET}"
echo ""
echo -e "  ${CYAN}Install location:${RESET} $INSTALL_DIR"
echo -e "  ${CYAN}Config location:${RESET}  $INSTALL_DIR/config/"
echo ""
echo -e "  ${BOLD}Available commands:${RESET}"
echo -e "  ${CYAN}raychd start${RESET}        — Start IRC server"
echo -e "  ${CYAN}raychd stop${RESET}         — Stop IRC server"
echo -e "  ${CYAN}raychd status${RESET}       — Check server status"
echo -e "  ${CYAN}raychd connect${RESET}      — Connect to IRC channel"
echo -e "  ${CYAN}raychd ddns${RESET}         — Update Dynamic DNS"
echo -e "  ${CYAN}raychd install-env${RESET}  — Install environments"
echo ""
echo -e "  ${YELLOW}Restart your terminal or run:${RESET}"
echo -e "  ${CYAN}source ~/.bashrc${RESET}"
echo ""
