# ==============================================================================
# Define Dependencies
POSTGRES := postgres:16.4
GENI     := ghcr.io/emilpriver/geni:v1.1.5


# ==============================================================================
# Dependencies
deps-install:
	brew update
	brew list pgcli || brew install pgcli
	brew list geni || brew install geni

deps-docker:
	docker pull $(GENI) & \
	docker pull $(POSTGRES) & \
	wait;

# ==============================================================================
# Docker Compose
compose-db-up:
	docker compose --profile db up

compose-db-down:
	docker compose --profile db down

# ==============================================================================
# Administration
pgcli:
	pgcli postgresql://postgres:postgres@localhost:5432/bookstore
