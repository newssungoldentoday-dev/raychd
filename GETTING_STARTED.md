# Getting Started with Ray Chad

This guide provides detailed instructions for setting up, configuring, and running Ray Chad IRC server.

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Running the Server](#running-the-server)
5. [Connecting Clients](#connecting-clients)
6. [Server Management](#server-management)

## System Requirements

### Minimum Requirements

- CPU: 1 core
- RAM: 512 MB
- Disk: 500 MB
- OS: Linux/Unix (including macOS)

### Recommended Requirements

- CPU: 2+ cores
- RAM: 2+ GB
- Disk: 5+ GB
- OS: Ubuntu 20.04 LTS or newer

### Docker Requirements

- Docker 19.03 or newer
- Docker Compose (optional, for advanced deployments)

## Installation

### Method 1: Docker Installation (Recommended for Production)

1. **Clone the repository**

```bash
git clone https://github.com/newssungoldentoday-dev/raychd.git
cd raychd
```

2. **Build the Docker image**

```bash
docker build -t raychd:latest .
```

3. **Verify the build**

```bash
docker images | grep raychd
```

### Method 2: Manual Installation

1. **Clone the repository**

```bash
git clone https://github.com/newssungoldentoday-dev/raychd.git
cd raychd
```

2. **Make scripts executable**

```bash
chmod +x *.sh
find . -name "*.sh" -type f -exec chmod +x {} \;
```

3. **Install dependencies** (if needed)

```bash
# For bash-based projects, standard Unix utilities should suffice
# Verify you have: bash, grep, sed, awk, nc, etc.
which bash grep sed awk nc
```

## Configuration

### Configuration Files

Configuration is managed through files in the `config/` directory:

```
config/
├── server.conf      # Main server configuration
├── channels.conf    # Default channels
└── users.conf       # User management (optional)
```

### Basic Server Configuration

Edit `config/server.conf`:

```bash
# Server name
SERVER_NAME="raychd"

# Port to listen on
IRC_PORT=6667

# Maximum connections
MAX_CONNECTIONS=100

# Server message of the day
MOTD="Welcome to Ray Chad IRC Server"

# Enable SSL/TLS (optional)
USE_SSL=false
SSL_PORT=6697
```

### Channel Configuration

Edit `config/channels.conf`:

```bash
# Define default channels that should be created on startup
#general:Chat about anything
#help:Get help with the server
#announcements:Important announcements
```

### User Configuration (Optional)

For password-protected access, edit `config/users.conf`:

```bash
# Format: username:password_hash
admin:$2y$10$hashedpassword
```

## Running the Server

### Docker Method

1. **Start the container**

```bash
docker run -d \
  --name raychd \
  -p 6667:6667 \
  -v $(pwd)/config:/app/config \
  -v $(pwd)/logs:/app/logs \
  raychd:latest
```

2. **View logs**

```bash
docker logs -f raychd
```

3. **Stop the container**

```bash
docker stop raychd
```

### Manual Method

1. **Start the server**

```bash
./start.sh
```

2. **Monitor the server**

```bash
tail -f logs/raychd.log
```

3. **Stop the server**

```bash
./stop.sh
```

## Connecting Clients

### Using a Web-based Client

1. Open your web browser
2. Go to https://kiwiirc.com
3. Set:
   - **Network**: Custom
   - **Server**: your-server-ip
   - **Port**: 6667
4. Click **Start**

### Using a Desktop Client (HexChat Example)

1. Launch HexChat
2. Go to **Network List**
3. Click **Add**
4. Set:
   - **Network**: Ray Chad
   - **Servers**: your-server-ip/6667
5. Click **Connect**

### Using Terminal (irssi Example)

```bash
irssi -c your-server-ip -p 6667 -n yournickname
```

## Server Management

### Common Commands

```bash
# Check if server is running
./status.sh

# View recent logs
./logs.sh

# Restart the server
./restart.sh

# View server statistics
./stats.sh
```

### Monitoring

Monitor server activity:

```bash
# Real-time log monitoring
tail -f logs/raychd.log

# Check active connections
netstat -an | grep 6667

# Monitor resource usage
top -p $(pgrep -f raychd)
```

### Backup and Recovery

```bash
# Backup configuration and logs
tar -czf raychd-backup-$(date +%Y%m%d).tar.gz config/ logs/

# Restore from backup
tar -xzf raychd-backup-*.tar.gz
```

## Advanced Configuration

### SSL/TLS Support

For secure connections:

1. **Generate certificates**

```bash
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
```

2. **Update configuration**

```bash
USE_SSL=true
SSL_PORT=6697
SSL_CERT=/path/to/cert.pem
SSL_KEY=/path/to/key.pem
```

3. **Restart the server**

```bash
./restart.sh
```

### Performance Tuning

Adjust `config/server.conf` for your needs:

```bash
# Increase for more simultaneous connections
MAX_CONNECTIONS=500

# Adjust message queue size
MESSAGE_QUEUE_SIZE=1000

# Set connection timeout (seconds)
CONNECTION_TIMEOUT=300
```

## Troubleshooting

For issues during setup, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Next Steps

- Join the community in [CONTRIBUTING.md](CONTRIBUTING.md)
- Review [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues
- Check project documentation in the `docs/` folder

---

**Need Help?** Open an issue on the repository or check the troubleshooting guide.
