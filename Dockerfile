FROM ubuntu:22.04

LABEL maintainer="newssungoldentoday-dev"
LABEL description="Ray Chad IRC Server - Powered by InspIRCd"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV INSPIRCD_PREFIX=/usr/local/inspircd

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    openssl \
    libssl-dev \
    pkg-config \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone and build InspIRCd
RUN git clone https://github.com/inspircd/inspircd.git /tmp/inspircd && \
    cd /tmp/inspircd && \
    ./configure --prefix=$INSPIRCD_PREFIX --enable-gnutls && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/inspircd

# Clone Ray Chad and copy configuration
RUN git clone https://github.com/newssungoldentoday-dev/raychd.git /tmp/raychd && \
    cp /tmp/raychd/inspircd.conf $INSPIRCD_PREFIX/conf/ && \
    rm -rf /tmp/raychd

# Create non-root user for running the server
RUN useradd -m -s /bin/bash inspircd && \
    chown -R inspircd:inspircd $INSPIRCD_PREFIX

# Switch to non-root user
USER inspircd

# Expose ports
# 6667: Standard IRC port
# 6697: Secure IRC port (SSL/TLS)
# 7000: Server linking port
EXPOSE 6667 6697 7000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD $INSPIRCD_PREFIX/bin/inspircd status || exit 1

# Start InspIRCd in foreground (important for Docker)
CMD ["bash", "-c", "$INSPIRCD_PREFIX/bin/inspircd start -nofork"]
