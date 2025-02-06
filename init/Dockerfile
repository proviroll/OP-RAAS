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
RUN curl -sL https://golang.org/dl/go1.22.5.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="$PATH:/usr/local/go/bin"

# Install Node.js and pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm

# Install Foundry
ARG FOUNDRY_VERSION=${FOUNDRY_VERSION:-nightly-ef62fdbab638a275fc19a2ff8fe8951c3bd1d9aa}
RUN curl -L https://foundry.paradigm.xyz | sudo -E bash - \
    && . ~/.bashrc && foundryup -v "$FOUNDRY_VERSION"

# Add foundry to PATH in multiple ways to ensure it's available
ENV PATH="/root/.foundry/bin:${PATH}"
RUN echo 'export PATH="/root/.foundry/bin:$PATH"' >> /root/.bashrc && \
    echo 'export PATH="/root/.foundry/bin:$PATH"' >> /etc/profile && \
    ln -s /root/.foundry/bin/cast /usr/local/bin/cast

# Clone Optimism repository
ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ARG OP_VERSION=${OP_VERSION:-v1.8.0}
RUN mkdir -p ~/optimism && cd ~/optimism \
    && git clone $OP_REPO --depth 1 --branch $OP_VERSION --single-branch . \
    && git switch -c $OP_VERSION \
    && git submodule update --init --recursive --depth 1 \
    && go mod download && go mod tidy \
    && make -C op-node VERSION=$OP_VERSION op-node

# Copy and set permissions for scripts
COPY *.sh /script/
RUN chmod +x /script/*.sh

# Source bashrc in entrypoint
ENTRYPOINT ["/bin/bash", "-c", "\
    source /root/.bashrc && \
    chmod +x /script/*.sh && \
    source /script/1_init_environment.sh && \
    /script/2_faucet.sh && \
    /script/3_generate_config.sh && \
    /script/4_deploy_contract.sh && \
    /script/5_export_genesis.sh"]
