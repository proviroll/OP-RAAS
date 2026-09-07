#!/bin/bash
set -e

# Wait for op-node to be ready
until curl -s http://op-node:9545 > /dev/null 2>&1; do
    echo "Waiting for op-node..."
    sleep 5
done

# Wait for deployer files
until [ -f /app/.deployer/rollup.json ]
do
    echo "Waiting for rollup.json..."
    sleep 5
done

exec /app/op-batcher/bin/op-batcher \
    --l2-eth-rpc=http://op-geth:8545 \
    --rollup-rpc=http://op-node:9545 \
    --poll-interval=1s \
    --sub-safety-margin=6 \
    --num-confirmations=1 \
    --safe-abort-nonce-too-low-count=3 \
    --resubmission-timeout=30s \
    --rpc.addr=0.0.0.0 \
    --rpc.port=7545 \
    --rpc.enable-admin \
    --max-channel-duration=1 \
    --l1-eth-rpc=$L1_RPC_URL \
    --private-key=$GS_BATCHER_PRIVATE_KEY \
    --target-l1-tx-size-bytes=100000 \
    --target-num-frames=1 \
    --batch-type=0 \
    --data-availability-type=calldata