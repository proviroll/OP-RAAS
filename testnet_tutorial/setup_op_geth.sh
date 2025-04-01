#!/bin/bash
set -e

echo "Setting up op-geth repository..."
cd /app

# Clone op-geth repository
git clone https://github.com/ethereum-optimism/op-geth.git
cd op-geth

# Build geth
make geth

echo "op-geth setup complete!"