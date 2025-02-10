FROM ubuntu:22.04

WORKDIR /app

# Update system and install dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    jq \
    wget \
    curl \
    gnupg \
    git \
    make \
    bc \
    ca-certificates \
    && sudo rm -rf /var/lib/apt/lists/*

# Install Go
RUN curl -sL https://golang.org/dl/go1.23.6.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="$PATH:/usr/local/go/bin"

# Install Node.js and pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm

# Install Foundry
ARG FOUNDRY_VERSION=${FOUNDRY_VERSION:-nightly-ef62fdbab638a275fc19a2ff8fe8951c3bd1d9aa}
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup && \
    chmod +x /root/.foundry/bin/* && \
    ln -sf /root/.foundry/bin/cast /usr/local/bin/cast && \
    ln -sf /root/.foundry/bin/forge /usr/local/bin/forge && \
    ln -sf /root/.foundry/bin/anvil /usr/local/bin/anvil && \
    echo 'export PATH="/root/.foundry/bin:/usr/local/bin:$PATH"' >> /etc/profile && \
    echo 'export PATH="/root/.foundry/bin:/usr/local/bin:$PATH"' >> /etc/bash.bashrc && \
    echo 'export PATH="/root/.foundry/bin:/usr/local/bin:$PATH"' >> /root/.bashrc

ENV PATH="/root/.foundry/bin:/usr/local/bin:${PATH}"

# Verify foundry installation
RUN cast --version || exit 1
ENV PATH="/root/.foundry/bin:${PATH}"

# Clone Optimism repository
ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ARG OP_VERSION=${OP_VERSION:-v1.9.5}
RUN mkdir -p ~/optimism && cd ~/optimism \
    && git clone $OP_REPO --depth 1 --branch $OP_VERSION --single-branch . \
    && git switch -c $OP_VERSION \
    && git submodule update --init --recursive --depth 1 \
    && go mod download && go mod tidy \
    && make -C op-node VERSION=$OP_VERSION op-node

# Copy and set permissions for scripts
COPY *.sh /script/
RUN chmod +x /script/*.sh

ENTRYPOINT ["/bin/bash", "-c", "\
    chmod +x /script/*.sh && \
    source /script/1_init_environment.sh && \
    sleep infinity"]