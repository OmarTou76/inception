DOCKER_PATH = ./srcs/docker-compose.yaml

all: build up_detach

create_wordpress:
	mkdir -p /home/$$SUDO_USER/data/files

create_mariadb:
	mkdir -p /home/$$SUDO_USER/data/database

create_both: create_wordpress create_mariadb

build: create_both
	@echo "[*] Building images ..."
	@docker-compose -f $(DOCKER_PATH) build

up:
	@echo "[+] Creating containers ..."
	@docker-compose -f $(DOCKER_PATH) up

up_detach:
	@echo "[+] Creating containers in detached mode ..."
	@docker-compose -f $(DOCKER_PATH) up -d

down:
	@echo "[-] Stopping and deleting containers ..."
	@docker-compose -f $(DOCKER_PATH) down -v

stop:
	@echo "[!] Stopping containers ..."
	@docker-compose -f $(DOCKER_PATH) stop

remove_images:
	@echo "[!] Deleting images ..."
	@docker image rm -f $$(docker image ls -q)

remove_containers:
	@echo "[!] Deleting containers ..."
	@docker container rm -f $$(docker container ls -aq)

remove_volumes:
	@echo "[!] Deleting volumes ..."
	@docker volume rm $$(docker volume ls -q)

remove_networks:
	@echo "[!] Deleting networks ..."
	@docker network rm $$(docker network ls -q)

fclean: remove_containers remove_images remove_volumes remove_networks

re: fclean build up_detach

.PHONY: create_wordpress create_mariadb create_both build up up_detach down stop remove_images remove_containers remove_volumes remove_networks fclean re
