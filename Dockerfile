# Obsidian + Claude Code Hybrid Container
# Based on LinuxServer.io Obsidian image with added SSH and Claude Code CLI
FROM lscr.io/linuxserver/obsidian:latest

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Update apt and install dependencies
RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    curl \
    gnupg \
    git \
    nano \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (LTS) - Required for Claude Code
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (official apt repository)
RUN mkdir -p -m 755 /etc/apt/keyrings && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI via NPM
RUN npm install -g @anthropic-ai/claude-code

# Configure OpenSSH
# 1. Create the privilege separation directory
RUN mkdir -p /var/run/sshd

# 2. Update sshd_config
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Add custom initialization scripts and s6 service definitions
COPY root/ /

# Expose the SSH port (Obsidian ports 3000/3001 are exposed by base image)
EXPOSE 2222
