#!/bin/bash
set -e

echo "Starting Optimism deployment process..."

# Run setup scripts
/app/setup_optimism.sh
/app/setup_op_geth.sh
/app/deploy_rollup.sh
/app/run_node.sh

# Keep container running
tail -f /dev/null