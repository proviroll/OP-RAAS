#!/bin/bash
set -e

# Wait for op-node to be ready
until curl -s http://op-node:9545/health > /dev/null 2>&1; do
    echo "Waiting for op-node..."
    sleep 5
done

# Wait for deployer files
until [ -f /app/.deployer/addresses.json ]
do
    echo "Waiting for addresses.json..."
    sleep 5
done

# Get L2OutputOracleProxy address from the deployment
L2OO_ADDRESS=$(cat /app/.deployer/addresses.json | jq -r .L2OutputOracleProxy)

# Reference run_node.sh for proposer configuration
exec /app/optimism/op-proposer/bin/op-proposer \
    --poll-interval=12s \
    --rpc.addr=0.0.0.0 \
    --rpc.port=8560 \
    --rollup-rpc=http://op-node:9545 \
    --l2oo-address=$L2OO_ADDRESS \
    --private-key=$GS_PROPOSER_PRIVATE_KEY \
    --l1-eth-rpc=$L1_RPC_URL 