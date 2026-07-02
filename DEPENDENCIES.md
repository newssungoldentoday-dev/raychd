# Ray Chad IRC Server - All Dependencies

This document lists all dependencies required to build and run Ray Chad IRC Server.

## 🔧 Build Dependencies

### Core Build Tools
| Package | Purpose | Platforms |
|---------|---------|-----------|
| **gcc/g++** | C/C++ compiler | All Linux, macOS, Termux |
| **make** | Build automation | All Linux, macOS, Termux |
| **autoconf** | Configure script generator | All Linux, macOS, Termux |
| **automake** | Makefile generator | All Linux, macOS, Termux |
| **pkg-config** | Library compiler flags helper | All Linux, macOS, Termux |
| **git** | Version control | All platforms |

### SSL/TLS Libraries (REQUIRED)
| Package | Purpose | Ubuntu/Debian | CentOS/RHEL | Arch | Alpine | Termux | macOS |
|---------|---------|---------------|-------------|------|--------|--------|-------|
| **openssl** | SSL/TLS toolkit | openssl | openssl | openssl | openssl | openssl | openssl |
| **openssl-dev** | SSL development headers | libssl-dev openssl-dev | openssl-devel | (in base-devel) | openssl-dev | openssl-dev | (in openssl) |
| **libssl-dev** | Additional SSL libraries | libssl-dev | openssl-devel | (included) | openssl-dev | openssl-dev | (included) |

### Optional Libraries
| Package | Purpose | Used by |
|---------|---------|---------|
| **zlib** | Compression support | m_compress.so (optional) |
| **mysql-dev** | MySQL database support | m_mysql.so |
| **postgresql-dev** | PostgreSQL database support | m_pgsql.so |
| **pcre-dev** | Regular expression support | m_regex_pcre.so |
| **gnutls-dev** | GnuTLS encryption | m_ssl_gnutls.so (preferred) |

---

## 📦 Installation Commands by Platform

### Ubuntu 22.04 / 24.04 / Debian 11+

**Core dependencies:**
```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  autoconf \
  automake \
  openssl \
  libssl-dev \
  openssl-dev \
  pkg-config \
  git
```

**Optional packages:**
```bash
sudo apt-get install -y \
  zlib1g-dev \
  libmysqlclient-dev \
  libpq-dev \
  libpcre3-dev \
  libgnutls28-dev
```

### CentOS 7/8 / RHEL 7/8 / Fedora

**Core dependencies:**
```bash
sudo yum groupinstall -y "Development Tools"
sudo yum install -y \
  autoconf \
  automake \
  openssl \
  openssl-devel \
  pkg-config \
  git
```

**Fedora 35+:**
```bash
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y \
  autoconf \
  automake \
  openssl \
  openssl-devel \
  pkg-config \
  git
```

**Optional packages:**
```bash
sudo yum install -y \
  zlib-devel \
  mysql-devel \
  postgresql-devel \
  pcre-devel \
  gnutls-devel
```

### Arch Linux

**Core dependencies:**
```bash
sudo pacman -Sy --noconfirm \
  base-devel \
  autoconf \
  automake \
  openssl \
  pkg-config \
  git
```

**Optional packages:**
```bash
sudo pacman -S --noconfirm \
  zlib \
  mysql \
  postgresql \
  pcre \
  gnutls
```

### Alpine Linux

**Core dependencies:**
```bash
sudo apk add --no-cache \
  build-base \
  autoconf \
  automake \
  openssl \
  openssl-dev \
  pkg-config \
  git
```

**Optional packages:**
```bash
sudo apk add --no-cache \
  zlib-dev \
  mariadb-dev \
  postgresql-dev \
  pcre-dev \
  gnutls-dev
```

### Termux (Android)

**Core dependencies:**
```bash
pkg update
pkg install -y \
  build-essential \
  autoconf \
  automake \
  openssl \
  openssl-dev \
  pkg-config \
  git \
  clang \
  make
```

**Optional packages:**
```bash
pkg install -y \
  zlib-dev \
  openssl-dev
```

### macOS

**Core dependencies (Homebrew):**
```bash
# Install Homebrew first if needed:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
brew install \
  autoconf \
  automake \
  openssl \
  pkg-config \
  git
```

**Optional packages:**
```bash
brew install \
  zlib \
  mariadb \
  postgresql \
  pcre \
  gnutls
```

**Note:** You may need to set environment variables for OpenSSL:
```bash
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
```

### Windows (WSL/WSL2)

Use Ubuntu/Debian instructions:
```bash
sudo apt-get update
sudo apt-get install -y build-essential autoconf automake openssl libssl-dev openssl-dev pkg-config git
```

---

## ✅ Verification Commands

### Check Compiler
```bash
gcc --version
g++ --version
```

### Check OpenSSL
```bash
openssl version
pkg-config --modversion openssl
```

### Check Development Tools
```bash
make --version
autoconf --version
automake --version
pkg-config --version
git --version
```

### Check for SSL Headers
```bash
# Linux/Termux
ls -la /usr/include/openssl/

# macOS
ls -la /usr/local/opt/openssl/include/

# Check via pkg-config
pkg-config --cflags openssl
pkg-config --libs openssl
```

### Install Check Script
```bash
#!/bin/bash
echo "Checking Ray Chad dependencies..."
echo ""

tools=("gcc" "make" "autoconf" "automake" "pkg-config" "git" "openssl")

for tool in "${tools[@]}"; do
    if command -v $tool &> /dev/null; then
        version=$($tool --version 2>&1 | head -n1)
        echo "✅ $tool: installed - $version"
    else
        echo "❌ $tool: NOT installed"
    fi
done
```

---

## 🔒 SSL/TLS Configuration

### Enable GnuTLS (Recommended)
```bash
./configure --prefix=$HOME/raychd/inspircd --enable-gnutls
```

### Enable OpenSSL
```bash
./configure --prefix=$HOME/raychd/inspircd --enable-openssl
```

### With Custom OpenSSL Path (macOS)
```bash
./configure --prefix=$HOME/raychd/inspircd --enable-gnutls \
    LDFLAGS="-L/usr/local/opt/openssl/lib" \
    CPPFLAGS="-I/usr/local/opt/openssl/include" \
    PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
```

---

## 📊 Dependency Tree

```
Ray Chad IRC Server
├── InspIRCd (Core)
│   ├── gcc/g++ (build)
│   ├── make (build)
│   ├── autoconf (build)
│   ├── automake (build)
│   ├── openssl ✅ REQUIRED
│   ├── openssl-dev ✅ REQUIRED
│   └── libssl-dev (additional)
├── Git (for cloning)
└── Optional Modules
    ├── zlib (compression)
    ├── MySQL (database)
    ├── PostgreSQL (database)
    ├── PCRE (regex)
    └── GnuTLS (encryption)
```

---

## 🚀 Quick Dependency Install

### One-liner by Platform

**Ubuntu/Debian:**
```bash
sudo apt-get update && sudo apt-get install -y build-essential autoconf automake openssl libssl-dev openssl-dev pkg-config git
```

**CentOS/RHEL:**
```bash
sudo yum groupinstall -y "Development Tools" && sudo yum install -y openssl openssl-devel autoconf automake pkg-config git
```

**Arch:**
```bash
sudo pacman -Sy --noconfirm base-devel autoconf automake openssl pkg-config git
```

**Alpine:**
```bash
sudo apk add --no-cache build-base autoconf automake openssl openssl-dev pkg-config git
```

**Termux:**
```bash
pkg update && pkg install -y build-essential autoconf automake openssl openssl-dev pkg-config git
```

**macOS:**
```bash
brew update && brew install autoconf automake openssl pkg-config git
```

---

## ⚠️ Common Dependency Issues

### "openssl-dev not found"
```bash
# Ubuntu/Debian - use alternative
sudo apt-get install libssl-dev

# CentOS/RHEL - use
sudo yum install openssl-devel

# Check if OpenSSL is installed
openssl version
```

### "pkg-config not found"
```bash
# Ubuntu/Debian
sudo apt-get install pkg-config

# CentOS/RHEL
sudo yum install pkgconfig

# Arch
sudo pacman -S pkg-config

# Alpine
sudo apk add pkg-config

# Termux
pkg install pkg-config
```

### "autoconf/automake not found"
```bash
# Ubuntu/Debian
sudo apt-get install autoconf automake

# CentOS/RHEL
sudo yum install autoconf automake

# macOS
brew install autoconf automake
```

### Compilation Fails with OpenSSL Error
```bash
# Check OpenSSL installation
pkg-config --modversion openssl

# Try with explicit path (macOS)
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH"
```

---

## 📋 Complete Dependency Checklist

- [ ] GCC/Clang compiler (C++11 support minimum)
- [ ] GNU Make
- [ ] Autoconf
- [ ] Automake
- [ ] OpenSSL (openssl package)
- [ ] OpenSSL development files (openssl-dev/libssl-dev)
- [ ] pkg-config
- [ ] Git
- [ ] At least 100 MB free disk space
- [ ] At least 512 MB RAM

---

## 🔗 Related Documentation

- [INSTALL.md](INSTALL.md) - Installation guide
- [QUICK_START.md](QUICK_START.md) - Quick start guide
- [REQUIREMENTS.txt](REQUIREMENTS.txt) - System requirements
- [pkg-install](pkg-install) - Automated installer script

For issues or questions, visit: https://github.com/newssungoldentoday-dev/raychd/issues
