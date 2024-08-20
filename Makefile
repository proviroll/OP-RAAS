.PHONY: init run run-down explorer explorer-down buildx buildx-init buildx-run

# Define log files
LOG_DIR := logs
LOG_FILE_UP := $(LOG_DIR)/compose_up.log
LOG_FILE_DOWN := $(LOG_DIR)/compose_down.log

# Define versions with defaults
OP_VERSION ?= v1.8.0
FOUNDRY_VERSION ?= nightly-ef62fdbab638a275fc19a2ff8fe8951c3bd1d9aa
GETH_VERSION ?= v1.101315.2

init:
	@mkdir -p $(LOG_DIR)
	docker compose --env-file common.env -f init/docker-compose.yml -p op_raas_init up > $(LOG_FILE_UP) 2>&1 && \
	docker compose --env-file common.env -f init/docker-compose.yml -p op_raas_init down > $(LOG_FILE_DOWN) 2>&1

run:
	docker compose --env-file common.env -f run/docker-compose.yml -p op_raas_run up -d

run-down:
	docker compose --env-file common.env -f run/docker-compose.yml -p op_raas_run down

explorer:
	docker compose --env-file common.env -f scan/docker-compose.yml -p op_raas_explorer up -d

explorer-down:
	docker compose --env-file common.env -f scan/docker-compose.yml -p op_raas_explorer down

# buildx command
buildx: buildx-init buildx-run

buildx-init:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t chakrellah/op_raas_init:1.8.0 \
	-t chakrellah/op_raas_init:latest \
	--build-arg OP_VERSION=$(OP_VERSION) \
	--buid-arg FOUNDRY_VERSION=$(FOUNDRY_VERSION) \
	--push ./init

buildx-run:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t chakrellah/op_raas_run:1.8.0 \
	-t chakrellah/op_raas_run:latest \
	--build-arg OP_VERSION=$(OP_VERSION) \
	--build-arg GETH_VERSION=$(GETH_VERSION) \
	--push ./run
