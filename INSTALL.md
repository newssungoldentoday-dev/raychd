# How to Install Ray Chad IRC Server

Ray Chad is easy to install! Choose your preferred method below.

## ⚡ Fastest Method: One-Line Install

Copy and paste ONE of these commands into your terminal:

### Linux / macOS / WSL
```bash
curl -O https://raw.githubusercontent.com/newssungoldentoday-dev/raychd/main/pkg-install && chmod +x pkg-install && ./pkg-install
```

### Termux (Android)
```bash
curl https://raw.githubusercontent.com/newssungoldentoday-dev/raychd/main/pkg-install | bash
```

That's it! The script will automatically:
- ✅ Detect your OS
- ✅ Install all dependencies (including openssl-dev)
- ✅ Clone Ray Chad
- ✅ Build InspIRCd
- ✅ Deploy configuration
- ✅ Create shortcuts

---

## 📦 Method 2: Docker (Easiest)

### Prerequisites
- Docker installed

### Quick Start
```bash
# Clone Ray Chad
git clone https://github.com/newssungoldentoday-dev/raychd.git
cd raychd

# Start with Docker Compose
docker-compose up -d
```

Done! Server is running on:
- Port **6667** (standard IRC)
- Port **6697** (SSL/TLS)

Connect with any IRC client to `localhost:6667`

---

## 🔧 Method 3: Manual Installation

### Step 1: Install Dependencies

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y build-essential autoconf automake openssl libssl-dev openssl-dev pkg-config git
```

**Termux:**
```bash
pkg update
pkg install -y build-essential git openssl openssl-dev autoconf automake pkg-config
```

**macOS:**
```bash
brew install autoconf automake openssl git pkg-config
```

**CentOS/RHEL/Fedora:**
```bash
sudo yum groupinstall -y "Development Tools"
sudo yum install -y openssl-devel autoconf automake git pkg-config
```

**Arch Linux:**
```bash
sudo pacman -Sy --noconfirm base-devel openssl autoconf automake git pkg-config
```

**Alpine Linux:**
```bash
sudo apk add --no-cache build-base autoconf automake openssl-dev git pkg-config
```

### Step 2: Create Installation Directory
```bash
mkdir -p ~/raychd
cd ~/raychd
```

### Step 3: Clone Ray Chad
```bash
git clone https://github.com/newssungoldentoday-dev/raychd.git raychd-repo
```

### Step 4: Build InspIRCd
```bash
# Clone InspIRCd
git clone https://github.com/inspircd/inspircd.git

# Build
cd inspircd
./configure --prefix=$HOME/raychd/inspircd --enable-gnutls
make -j$(nproc)
make install
cd ..
```

### Step 5: Deploy Configuration
```bash
cp raychd-repo/inspircd.conf ~/raychd/inspircd/conf/
```

### Step 6: Start Server
```bash
~/raychd/inspircd/bin/inspircd start
```

---

## 🚀 After Installation

### Configure Ray Chad

Edit the configuration file:
```bash
nano ~/raychd/inspircd/conf/inspircd.conf
```

**Important: Change the admin password!**

Find this line:
```xml
<oper
	name="admin"
	password="change_this_password"
	hash="sha256"
	host="*@*"
	type="NetAdmin">
```

Generate a secure password hash:
```bash
~/raychd/inspircd/bin/inspircd --mkpasswd
```

Then update the password in the config.

### Server Commands

```bash
# Start server
~/raychd/inspircd/bin/inspircd start

# Stop server
~/raychd/inspircd/bin/inspircd stop

# Restart server
~/raychd/inspircd/bin/inspircd restart

# Check status
~/raychd/inspircd/bin/inspircd status

# View logs
tail -f ~/raychd/inspircd/data/logs/ircd.log
```

### Or Use Shortcuts (if created)

If the installation created shortcuts:

```bash
raychd start
raychd stop
raychd restart
raychd status
raychd logs
raychd edit
```

---

## 💬 Connect with IRC Client

### Download an IRC Client

- **HexChat** - https://hexchat.github.io/ (Recommended for beginners)
- **WeeChat** - https://weechat.org/
- **mIRC** - https://www.mirc.com/
- **Irssi** - https://irssi.org/
- **Kiwi IRC** (Web-based) - https://kiwiirc.com/

### Connection Details

In your IRC client, enter:

| Field | Value |
|-------|-------|
| **Server** | localhost (or your server IP) |
| **Port** | 6667 (unencrypted) or 6697 (SSL/TLS) |
| **Nickname** | Your username |
| **Username** | Optional |
| **Channels** | #general, #dev |

### Connect via HexChat

1. Open HexChat
2. Go to **Network List**
3. Click **Add**
4. Enter:
   - Network: `Ray Chad`
   - Host: `localhost` (or your server IP)
   - Port: `6667`
5. Click **Connect**

### Connect via Kiwi IRC (Web Browser)

1. Go to https://kiwiirc.com/
2. Enter server: `your-server-ip` (or `localhost`)
3. Choose a nickname
4. Click **Start**
5. Type `/join #general`

---

## ✅ Verify Installation

Check if server is running:

```bash
# Check process
ps aux | grep inspircd

# Check port
netstat -tlnp | grep 6667

# Connect as test
telnet localhost 6667
```

You should see IRC welcome message:
```
:raychd.local NOTICE * :*** Welcome to Ray Chad ***
```

---

## 🆘 Troubleshooting

### "Port 6667 already in use"
```bash
# Find what's using the port
sudo lsof -i :6667

# Kill it
sudo kill -9 <PID>

# Or change port in inspircd.conf
```

### "openssl-dev not found"
```bash
# Ubuntu/Debian - try this instead
sudo apt-get install libssl-dev

# CentOS/RHEL - use
sudo yum install openssl-devel

# Termux
pkg install openssl-dev
```

### "inspircd command not found"
```bash
# Use full path
~/raychd/inspircd/bin/inspircd start

# Or add to PATH
export PATH="$HOME/raychd/inspircd/bin:$PATH"
```

### Server won't start
```bash
# Check logs
tail -f ~/raychd/inspircd/data/logs/ircd.log

# Verify config
~/raychd/inspircd/bin/inspircd -c ~/raychd/inspircd/conf/inspircd.conf
```

---

## 📚 Next Steps

1. **Learn IRC Commands**: `/help`, `/join #channel`, `/msg user message`
2. **Create Channels**: `/join #mychannel`
3. **Set Channel Modes**: `/mode #channel +nt`
4. **Add More Users**: Share your server IP with friends
5. **Advanced Setup**: Read [GETTING_STARTED.md](GETTING_STARTED.md)

---

## 🔗 Quick Links

- 📖 [Quick Start](QUICK_START.md)
- 📚 [Full Guide](GETTING_STARTED.md)
- 📋 [Requirements](REQUIREMENTS.txt)
- ⚙️ [Config File](inspircd.conf)
- 🐛 [Report Issues](https://github.com/newssungoldentoday-dev/raychd/issues)

---

## 🎉 You're Ready!

Start chatting with Ray Chad now!

```bash
# One final check
~/raychd/inspircd/bin/inspircd status

# All set! 
echo "Ray Chad IRC Server is ready 🚀"
```

---

**Need help?** Check out the documentation or open an issue on GitHub! 💬
