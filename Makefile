up:
	DOCKER_BUILDKIT=1 docker compose up -d --build

down:
	docker compose down

logs:
	docker compose logs -f