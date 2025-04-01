#!/bin/bash
set -e

echo "Deploying Optimism rollup..."
cd /app

# Download op-deployer using the specific URL provided
# This points to an older release structure within the main optimism repo
OP_DEPLOYER_VERSION_STR="0.3.0-rc.5"
OP_DEPLOYER_TAG_ENCODED="op-deployer%2Fv${OP_DEPLOYER_VERSION_STR}"
OP_DEPLOYER_FILENAME="op-deployer-${OP_DEPLOYER_VERSION_STR}-linux-amd64.tar.gz"
OP_DEPLOYER_URL="https://github.com/ethereum-optimism/optimism/releases/download/${OP_DEPLOYER_TAG_ENCODED}/${OP_DEPLOYER_FILENAME}"
OP_DEPLOYER_DIR="op-deployer-${OP_DEPLOYER_VERSION_STR}-linux-amd64"

echo "Downloading op-deployer from specific URL: ${OP_DEPLOYER_URL}"
# Use the specific URL and save to the specific filename
curl -fL "${OP_DEPLOYER_URL}" -o "${OP_DEPLOYER_FILENAME}"

echo "Extracting op-deployer..."
# Use the specific filename
tar -xzf "${OP_DEPLOYER_FILENAME}"
echo "Cleaning up downloaded archive..."
# Use the specific filename
rm "${OP_DEPLOYER_FILENAME}" # Clean up the downloaded tarball

# Create cache directory if it doesn't exist
mkdir -p /app/op-cache

# Source environment variables
source /app/optimism/.envrc

# Source the .env file if it exists - use absolute path
if [ -f /app/.env ]; then
    set -a  # automatically export all variables
    source /app/.env
    cat /app/.env
    set +a  # stop automatically exporting
fi


# DEBUG: Print the addresses
echo "GS_ADMIN_ADDRESS: ${GS_ADMIN_ADDRESS}"    
echo "GS_SEQUENCER_ADDRESS: ${GS_SEQUENCER_ADDRESS}"
echo "GS_BATCHER_ADDRESS: ${GS_BATCHER_ADDRESS}"
echo "GS_PROPOSER_ADDRESS: ${GS_PROPOSER_ADDRESS}"

# Run op-deployer
cd "/app/${OP_DEPLOYER_DIR}"

# First run init to create all necessary files
echo "Initializing deployment context..."
./op-deployer init --l1-chain-id 11155111 --l2-chain-ids ${L2_CHAIN_ID} --workdir /app/.deployer

# Update only the zero addresses in the generated intent.toml
sed -i \
    -e "s|baseFeeVaultRecipient = \"0x0000000000000000000000000000000000000000\"|baseFeeVaultRecipient = \"${GS_ADMIN_ADDRESS}\"|" \
    -e "s|l1FeeVaultRecipient = \"0x0000000000000000000000000000000000000000\"|l1FeeVaultRecipient = \"${GS_ADMIN_ADDRESS}\"|" \
    -e "s|sequencerFeeVaultRecipient = \"0x0000000000000000000000000000000000000000\"|sequencerFeeVaultRecipient = \"${GS_ADMIN_ADDRESS}\"|" \
    -e "s|systemConfigOwner = \"0x0000000000000000000000000000000000000000\"|systemConfigOwner = \"${GS_ADMIN_ADDRESS}\"|" \
    -e "s|unsafeBlockSigner = \"0x0000000000000000000000000000000000000000\"|unsafeBlockSigner = \"${GS_SEQUENCER_ADDRESS}\"|" \
    -e "s|batcher = \"0x0000000000000000000000000000000000000000\"|batcher = \"${GS_BATCHER_ADDRESS}\"|" \
    -e "s|proposer = \"0x0000000000000000000000000000000000000000\"|proposer = \"${GS_PROPOSER_ADDRESS}\"|" \
    /app/.deployer/intent.toml

echo "intent.toml updated"
cat /app/.deployer/intent.toml

echo "Running op-deployer apply..."
# DEBUG: Print the L1_RPC_URL & PRIVATE_KEY values
echo "DEBUG: L1_RPC_URL is set to: '$L1_RPC_URL'"
echo "DEBUG: PRIVATE_KEY is set to: '$PRIVATE_KEY'"

# Apply the deployment
./op-deployer --cache-dir=/app/op-cache apply --workdir=/app/.deployer --l1-rpc-url="$L1_RPC_URL" --private-key="$PRIVATE_KEY"

# Generate config files
echo "Generating config files..."
./op-deployer inspect genesis --workdir /app/.deployer ${L2_CHAIN_ID} > /app/.deployer/genesis.json
./op-deployer inspect rollup --workdir /app/.deployer ${L2_CHAIN_ID} > /app/.deployer/rollup.json

echo "Config files generated"
echo "genesis.json:"
cat /app/.deployer/genesis.json
echo "rollup.json:"
cat /app/.deployer/rollup.json

echo "Optimism deployment script finished."