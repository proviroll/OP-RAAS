#!/bin/bash
set -e

echo "Starting Optimism deployment process..."

# Run only necessary setup scripts
/app/setup-optimism.sh
/app/deploy-rollup.sh

# Keep container running until other services are done
tail -f /dev/null 