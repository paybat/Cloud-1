# Local project layout uses srcs/; the Ansible VM layout keeps these at the
# application root.
COMPOSE_FILE ?= $(if $(wildcard srcs/docker-compose.yml),srcs/docker-compose.yml,docker-compose.yml)
ENV_FILE ?= $(if $(wildcard srcs/.env),srcs/.env,.env)
DOCKER_COMPOSE ?= docker compose

-include $(ENV_FILE)
export

all: up

prepare:
	@mkdir -p "$(WORDPRESSVOLUMEPATH)" "$(MARIADBVOLUMEPATH)"

build: prepare
	$(DOCKER_COMPOSE) --env-file "$(ENV_FILE)" -f "$(COMPOSE_FILE)" build

up: prepare
	$(DOCKER_COMPOSE) --env-file "$(ENV_FILE)" -f "$(COMPOSE_FILE)" up -d --build

down:
	$(DOCKER_COMPOSE) --env-file "$(ENV_FILE)" -f "$(COMPOSE_FILE)" down --remove-orphans

clean: down

fclean:
	$(DOCKER_COMPOSE) --env-file "$(ENV_FILE)" -f "$(COMPOSE_FILE)" down --volumes --rmi local --remove-orphans
	@if [ -n "$(WORDPRESSVOLUMEPATH)" ]; then rm -rf -- "$(WORDPRESSVOLUMEPATH)"; fi
	@if [ -n "$(MARIADBVOLUMEPATH)" ]; then rm -rf -- "$(MARIADBVOLUMEPATH)"; fi

re: fclean all

.PHONY: all prepare build up down clean fclean re
