# OP-RAAS
This repository help deploy Optimism on a User-friendly way


It support 4 steps to operate OP Stack node
|  Name      | Description                                       | Command      |
| :--------: | ------------------------------------------------- | ------------ |
|  `init`    | deploy bridge contracts and generate l2 configs.  | `make init`  |
|  `run`     | run optimism node using generated configs.        | `make run`   |
|  `scan`    | run blockchain explorer using blockscout.         | `make scan`  |
|  `bridge`  | transfer eth and tokens between L1 and L2.        | `make bridge`|

## Prerequisite
- makefile, docker, docker-compose
- L1 RPC and Beacon endpoint (use PublicNode experimentally)
- faucet private key (for charging eth to proposer, batcher, admin)

## Quick Start
1. Clone this repository `git clone https://github.com/luminalink-ai/op-raas.git`
2. Check and select chain configuration in `common.env` and `/envs/{server.env}`
3. Run command `make init`. to generate `address.ini`, from the `common.env`
4. Run command `make run`, to run the OP stack either on the Superchain or on one of the custom chains, and `make run-down` to stop them.
5. Run command `make explorer` to run explorer services and `make explorer-down` to stop them,
6. !TODO `make bridge`

## Configuration
### Directory
- `CONFIG_DIR`: Path to store config files (default `../config`)
- `EXECUTION_DATA_DIR`: Path to store execution layer data (default `../data-execution`)
- `SCAN_DATA_DIR`: Path to store explorer data (default `../data-scan`)

### L1 chain
- `L1_CHAIN_ID`: L1 chain id (default `11155111`)
- `L1_RPC_KIND`: The type of RPC provider (default `standard`)
- `L1_RPC_URL`: L1 RPC endpoint (default `publicNode`)
- `L1_BEACON_URL`: L1 Beacon endpoint (default `publicNode`)

### L2 chain
- `L2_CHAIN_ID`: Your L2 chain id
- `L2_CHAIN_NAME`: Your L2 chain name
- `L2_RPC_URL`: Your L2 RPC endpoint
- `L2_SCAN_URL`: L2 Explore endpoint
- `L2_BRIDGE_URL`: L2 Bridge endpoint
- `ALT_DA_SERVER`: ALT DA server url; if empty, use eth DA

### init node
- `PRIORITY_GAS_PRICE`: Gas wei price using deploy contracts (default `10000`)
- `FAUCET_ADDRESS`: Charging address
- `FAUCET_PRIVATE_KEY`: Charging private key; Be careful about security
- `FAUCET_AMOUNT_ADMIN`: Faucet amount eth to admin (default `0.5`)
- `FAUCET_AMOUNT_BATCHER`: Faucet amount eth to batcher (default `0.2`)
- `FAUCET_AMOUNT_PROPOSER`: Faucet amount eth to proposer (default `0.1`)
- `GOVERNANCE_TOKEN_SYMBOL`: Governance token symbol

### run node
- `RUN_MODE`: Run mode ( sequencer or replica ) (default `sequencer`)
- `DATA_AVAILABILITY_TYPE`: Data availability type (default `blobs`)
- `MAX_CHANNEL_DURATION`: Batch time submitted to the L1 (default `1500`)
- `SEQUENCER_HTTP`: Sequencer endpoint
- `P2P_BOOTNODES`: Bootnode enr address

# DevOPS Guild 
Ethereum dev prespective : 
- How infrastructure can streamline L2 setups.


# Notes about each section of the presentation
## Introduction:
- In this presentation, we will be covering a workshop that will be focused on Optimistic rollups, we will see more in details how to deploy an L2 rollup by, initializing, generating rollup configurations and genesis file, deploying necessary L1 contracts, and run the different services, i.e batcher, sequencer (node), proposer, all based on Optimism framework on custom Sepolia chain.


## Repo explanation: 
This repository help deploy the entire process of setting up an Optimism stack on testnet/mainnet, with a custom Ethereum verifier and Bridge that helps deposit to L2 and whithdraw to L1.

# Invitation:
- Hey there's an opportunity this week to discuss RollUps setup, where we will talk about how infrastracture team can streamline L2 chain configurations and deployments of rollups. There will be a workshop focused on Optimistic rollups, later we can see how ZK ones emerge into Ethereum.

Don't forget to join us on the 12 September at 04PM CET. 

Thank you!


