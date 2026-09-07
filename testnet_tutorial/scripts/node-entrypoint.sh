#!/bin/bash
set -e

# Wait for op-geth to be ready
until curl -s http://op-geth:8551 > /dev/null 2>&1; do
    echo "Waiting for op-geth..."
    sleep 5
done

# Wait for deployer files
until [ -f /app/.deployer/rollup.json ]
do
    echo "Waiting for rollup.json..."
    sleep 5
done

# Reference run_node.sh lines 47-59 for configuration
exec /app/op-node/bin/op-node \
    --l2=http://op-geth:8551 \
    --l2.jwt-secret=/app/jwt/jwt.txt \
    --sequencer.enabled \
    --sequencer.l1-confs=0 \
    --verifier.l1-confs=0 \
    --rollup.config=/app/.deployer/rollup.json \
    --rpc.addr=0.0.0.0 \
    --p2p.disable \
    --rpc.enable-admin \
    --p2p.sequencer.key=$GS_SEQUENCER_PRIVATE_KEY \
    --l1=$L1_RPC_URL \
    --l1.rpckind=$L1_RPC_KIND \
    --l1.trustrpc \
    --l1.beacon="https://ethereum-sepolia-beacon-api.publicnode.com/"
