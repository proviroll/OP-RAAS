#!/bin/bash
set -e

# Generate JWT secret for authentication
mkdir -p /app/jwt
openssl rand -hex 32 > /app/jwt/jwt.txt

# Wait for deployer files to be available
until [ -f /app/.deployer/genesis.json ]
do
    echo "Waiting for genesis.json..."
    sleep 5
done

# Initialize op-geth with genesis file
cd /app/op-geth
mkdir -p datadir
./build/bin/geth init --state.scheme=hash --datadir=datadir /app/.deployer/genesis.json

# Start geth
exec ./build/bin/geth \
    --datadir=datadir \
    --http \
    --http.corsdomain="*" \
    --http.vhosts="*" \
    --http.addr=0.0.0.0 \
    --http.api=web3,debug,eth,txpool,net,engine \
    --ws \
    --ws.addr=0.0.0.0 \
    --ws.port=8546 \
    --ws.origins="*" \
    --ws.api=debug,eth,txpool,net,engine \
    --syncmode=full \
    --gcmode=archive \
    --nodiscover \
    --maxpeers=0 \
    --networkid=42069 \
    --authrpc.vhosts="*" \
    --authrpc.addr=0.0.0.0 \
    --authrpc.port=8551 \
    --authrpc.jwtsecret=/app/jwt/jwt.txt \
    --rollup.disabletxpoolgossip=true 