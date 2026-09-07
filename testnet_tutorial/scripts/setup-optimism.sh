#!/bin/bash
set -e

echo "Setting up Optimism environment..."
cd /app/optimism

# Copy environment file if it doesn't exist
if [ ! -f ".envrc" ]; then
  echo "Creating .envrc file..."
  cp .envrc.example .envrc

  # Generate wallet configurations
  echo "Generating wallet configurations..."
  WALLET_OUTPUT=$(./packages/contracts-bedrock/scripts/getting-started/wallets.sh)

  # Extract the wallet information and append to .envrc
  echo "# Admin account" >> .envrc
  grep "GS_ADMIN_ADDRESS" <<< "$WALLET_OUTPUT" >> .envrc
  grep "GS_ADMIN_PRIVATE_KEY" <<< "$WALLET_OUTPUT" >> .envrc

  echo "# Proposer account" >> .envrc
  grep "GS_PROPOSER_ADDRESS" <<< "$WALLET_OUTPUT" >> .envrc
  grep "GS_PROPOSER_PRIVATE_KEY" <<< "$WALLET_OUTPUT" >> .envrc

  echo "# Batcher account" >> .envrc
  grep "GS_BATCHER_ADDRESS" <<< "$WALLET_OUTPUT" >> .envrc
  grep "GS_BATCHER_PRIVATE_KEY" <<< "$WALLET_OUTPUT" >> .envrc

  echo "# Sequencer account" >> .envrc
  grep "GS_SEQUENCER_ADDRESS" <<< "$WALLET_OUTPUT" >> .envrc
  grep "GS_SEQUENCER_PRIVATE_KEY" <<< "$WALLET_OUTPUT" >> .envrc
fi

echo "Optimism environment setup complete!"