.PHONY: help start stop restart logs status clean backup build pull

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

start: ## Start all services
	podman-compose up -d

stop: ## Stop all services
	podman-compose down

restart: ## Restart all services
	podman-compose restart

logs: ## Follow logs from all services
	podman-compose logs -f

logs-arkcase: ## Follow ArkCase core logs only
	podman-compose logs -f arkcase-core

logs-db: ## Follow database logs only
	podman-compose logs -f postgres

status: ## Show status of all services
	podman-compose ps

health: ## Check health of all services
	@podman ps --format "table {{.Names}}\t{{.Status}}" | grep arkcase

pull: ## Pull latest images
	podman-compose pull

build: ## Build custom images (if any)
	podman-compose build

clean: ## Stop and remove all containers, networks (keeps volumes)
	podman-compose down

clean-all: ## Stop and remove everything including volumes (WARNING: DELETES DATA!)
	@echo "WARNING: This will delete all data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		podman-compose down -v; \
	fi

backup-db: ## Backup PostgreSQL database
	@mkdir -p backups
	podman exec arkcase-postgres pg_dump -U arkcase arkcase > backups/arkcase_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "Database backed up to backups/arkcase_$(shell date +%Y%m%d_%H%M%S).sql"

backup-volumes: ## Show volume locations for manual backup
	@echo "Volume locations:"
	@podman volume inspect arkcase_postgres-data --format '{{.Mountpoint}}'
	@podman volume inspect arkcase_alfresco-data --format '{{.Mountpoint}}'
	@podman volume inspect arkcase_arkcase-data --format '{{.Mountpoint}}'

restore-db: ## Restore database from backup file (usage: make restore-db BACKUP=backups/file.sql)
	@if [ -z "$(BACKUP)" ]; then \
		echo "Error: Please specify BACKUP file, e.g., make restore-db BACKUP=backups/arkcase_20240101.sql"; \
		exit 1; \
	fi
	@cat $(BACKUP) | podman exec -i arkcase-postgres psql -U arkcase arkcase

shell-arkcase: ## Open shell in ArkCase container
	podman exec -it arkcase-core /bin/bash

shell-db: ## Open PostgreSQL shell
	podman exec -it arkcase-postgres psql -U arkcase arkcase

update: pull restart ## Pull latest images and restart

prune: ## Clean up unused containers, networks, images
	podman system prune -f

prune-all: ## Clean up everything including volumes (WARNING!)
	@echo "WARNING: This will delete all unused volumes!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		podman system prune -a --volumes -f; \
	fi

install-systemd: ## Install systemd service for auto-start
	@echo "Creating systemd service..."
	@sudo cp arkcase.service /etc/systemd/system/
	@sudo systemctl daemon-reload
	@sudo systemctl enable arkcase.service
	@echo "Systemd service installed. Use 'sudo systemctl start arkcase' to start."

stats: ## Show resource usage statistics
	podman stats --no-stream

network: ## Show network information
	podman network inspect arkcase_arkcase-network

volumes: ## List all volumes
	podman volume ls | grep arkcase
