FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    pkg-config \
    cmake \
    clang \
    lldb \
    lld \
    libssl-dev \
    wget \
    bc \
    jq \
    direnv \
    software-properties-common \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install Go 1.21.6
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && \
    rm go1.21.6.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install pnpm
RUN npm install -g pnpm@8.15.9

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && \
    export PATH="$PATH:$HOME/.foundry/bin" && \
    /root/.foundry/bin/foundryup
ENV PATH=$PATH:/root/.foundry/bin

# Create directories
RUN mkdir -p /app/optimism /app/op-geth /app/op-cache /app/.deployer

WORKDIR /app

RUN git clone https://github.com/ethereum-optimism/optimism.git && \
    cd optimism && \
    git checkout tutorials/chain && \
    pnpm install && \
    make op-node op-batcher op-proposer

# Create directories (update existing RUN command)
RUN mkdir -p /app/op-geth /app/op-cache /app/.deployer


# Copy scripts
COPY entrypoint.sh /app/entrypoint.sh
COPY setup_optimism.sh /app/setup_optimism.sh
COPY setup_op_geth.sh /app/setup_op_geth.sh
COPY deploy_rollup.sh /app/deploy_rollup.sh

# Make scripts executable
RUN chmod +x /app/*.sh

ENTRYPOINT ["/app/entrypoint.sh"]