#!/bin/bash

# Ray Chad IRC Server - Bash Shortcut Setup
# Add this to your ~/.bashrc or ~/.zshrc to enable convenient commands

# Set Ray Chad installation directory (modify if different)
RAYCHD_HOME="${RAYCHD_HOME:-$HOME/raychd}"
INSPIRCD_BIN="$RAYCHD_HOME/inspircd/bin/inspircd"

# Ray Chad command wrapper
raychd() {
    case "$1" in
        start)
            echo "🚀 Starting Ray Chad IRC Server..."
            $INSPIRCD_BIN start
            sleep 1
            echo "✅ Ray Chad started successfully!"
            echo "📊 Check status: raychd status"
            ;;
        stop)
            echo "⏹️  Stopping Ray Chad IRC Server..."
            $INSPIRCD_BIN stop
            sleep 1
            echo "✅ Ray Chad stopped!"
            ;;
        restart)
            echo "🔄 Restarting Ray Chad IRC Server..."
            $INSPIRCD_BIN restart
            sleep 1
            echo "✅ Ray Chad restarted successfully!"
            ;;
        status)
            echo "📊 Ray Chad Server Status:"
            echo "================================"
            if $INSPIRCD_BIN status 2>/dev/null; then
                echo "✅ Server is RUNNING"
            else
                echo "❌ Server is NOT RUNNING"
            fi
            echo "================================"
            ;;
        logs)
            echo "📋 Ray Chad Server Logs (Ctrl+C to exit):"
            echo "================================"
            tail -f "$RAYCHD_HOME/inspircd/data/logs/ircd.log"
            ;;
        edit)
            echo "✏️  Opening configuration file..."
            ${EDITOR:-nano} "$RAYCHD_HOME/inspircd/conf/inspircd.conf"
            echo "⚠️  Remember to restart server for changes to take effect:"
            echo "   raychd restart"
            ;;
        config)
            echo "📄 Configuration file location:"
            echo "   $RAYCHD_HOME/inspircd/conf/inspircd.conf"
            ;;
        info)
            echo "ℹ️  Ray Chad IRC Server Information:"
            echo "================================"
            echo "Installation: $RAYCHD_HOME"
            echo "Binary: $INSPIRCD_BIN"
            echo "Config: $RAYCHD_HOME/inspircd/conf/inspircd.conf"
            echo "Logs: $RAYCHD_HOME/inspircd/data/logs/ircd.log"
            echo "================================"
            ;;
        connect)
            echo "💬 Connection Information:"
            echo "================================"
            echo "Server: localhost or $(hostname -I | awk '{print $1}')"
            echo "Port: 6667 (standard) or 6697 (SSL/TLS)"
            echo "Channels: #general, #dev"
            echo "================================"
            ;;
        help)
            cat << 'EOF'
Ray Chad IRC Server - Command Shortcuts
================================

Usage: raychd {command}

Commands:
  start       - Start Ray Chad IRC server
  stop        - Stop Ray Chad IRC server
  restart     - Restart Ray Chad IRC server
  status      - Show server status
  logs        - Show real-time server logs
  edit        - Edit configuration file
  config      - Show configuration file location
  info        - Show Ray Chad information
  connect     - Show connection details
  help        - Show this help message

Examples:
  raychd start
  raychd status
  raychd logs
  raychd edit
  raychd restart

For more information, visit: https://github.com/newssungoldentoday-dev/raychd

EOF
            ;;
        *)
            if [ -z "$1" ]; then
                echo "Ray Chad IRC Server - type 'raychd help' for usage"
            else
                echo "❌ Unknown command: $1"
                echo "Type 'raychd help' for available commands"
            fi
            return 1
            ;;
    esac
}

# Export the function so it's available in subshells
export -f raychd
export RAYCHD_HOME INSPIRCD_BIN
