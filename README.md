# OP-RAAS-Init
This repository does help launch Optimism on User-friendly way


It support steps to operate OP Stack node
|  Name      | Description                                       | Command      |
| :--------: | ------------------------------------------------- | ------------ |
|  `init`    | deploy bridge contracts and generate l2 configs.  | `make init`  |


## Prerequisite
- makefile, docker, docker-compose
- L1 RPC and Beacon endpoint (use PublicNode experimentally)
- faucet private key (for charging eth to proposer, batcher, admin)

## Quick Start
1. Clone this repository `git clone https://github.com/luminalink-ai/op-raas.git`
2. Check and select chain configuration in `common.env` and `/envs/{server.env}`
3. Run Command in sequence to `make init`, `make run`, `make scan`, `make bridge`
