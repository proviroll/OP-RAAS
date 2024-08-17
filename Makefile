.PHONY: init buildx buildx-init

init:
	docker compose --env-file common.env -f init/docker-compose.yml -p op_raas_init up && \
	docker compose --env-file common.env -f init/docker-compose.yml -p op_raas_init down

# buildx command
buildx: buildx-init 

buildx-init:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t chakrellah/op_raas_init:1.8.0 \
	-t chakrellah/op_raas_init:latest \
	--push ./init
