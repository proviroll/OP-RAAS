.PHONY: init buildx buildx-init

# Define log files
LOG_DIR := logs
LOG_FILE_UP := $(LOG_DIR)/compose_up.log
LOG_FILE_DOWN := $(LOG_DIR)/compose_down.log

init:
	@mkdir -p $(LOG_DIR)
	docker compose --env-file common.env -f init/docker-compose.yml -p op_raas_init up > $(LOG_FILE_UP) 2>&1 && \
	docker compose --env-file common.env -f init/docker-compose.yml -p op_raas_init down > $(LOG_FILE_DOWN) 2>&1

# buildx command
buildx: buildx-init 

buildx-init:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t chakrellah/op_raas_init:1.8.0 \
	-t chakrellah/op_raas_init:latest \
	--push ./init
