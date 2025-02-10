#!/bin/bash
set -eu

echo "[4/5] : deploy contract"
echo "L1_RPC_URL: $L1_RPC_URL"
echo "ADMIN_PUBLIC_KEY: $ADMIN_PUBLIC_KEY"
echo "ADMIN_PRIVATE_KEY: $ADMIN_PRIVATE_KEY"
echo "PRIORITY_GAS_PRICE: $PRIORITY_GAS_PRICE"
echo "L1_CHAIN_ID: $L1_CHAIN_ID"
echo "DEPLOYMENT_CONTEXT: $DEPLOYMENT_CONTEXT"
echo "SALT: $IMPL_SALT"


cd ~/optimism/packages/contracts-bedrock && \
DEPLOY_CONFIG_PATH="./deployments/$DEPLOYMENT_CONTEXT/.deploy" \
forge script scripts/deploy/Deploy.s.sol:Deploy \
  --private-key $ADMIN_PRIVATE_KEY \
  --broadcast \
  --rpc-url $L1_RPC_URL \
  --priority-gas-price $PRIORITY_GAS_PRICE \
  --gas-limit 5000000

echo "[deploy contract done!]"

CONTRACT_ADDRESSES_PATH="./deployments/$L1_CHAIN_ID-deploy.json" \
DEPLOY_CONFIG_PATH="./deployments/$DEPLOYMENT_CONTEXT/.deploy" \
FORK="ecotone" \
forge script scripts/L2Genesis.s.sol:L2Genesis \
  --sig 'runWithStateDump()' \
  --rpc-url $L1_RPC_URL
