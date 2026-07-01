COMPOSE ?= docker compose
CONTROLLER ?= controller
CONTROLLER_EXEC = $(COMPOSE) exec -T $(CONTROLLER) su - ansuser -c
HADOLINT_IMAGE ?= hadolint/hadolint:v2.14.0-debian
SHELLCHECK_IMAGE ?= koalaman/shellcheck:v0.11.0
TRIVY_IMAGE ?= aquasec/trivy:0.71.2

.PHONY: build up bootstrap ping playbook lint lint-ansible lint-dockerfiles lint-shell scan down clean

build:
	$(COMPOSE) build --pull

up:
	$(COMPOSE) up -d --wait

bootstrap:
	$(CONTROLLER_EXEC) 'cd /workspace && bash script/bootstrap.sh'

ping:
	$(CONTROLLER_EXEC) 'cd /workspace && ansible managed -m ping'

playbook:
	$(CONTROLLER_EXEC) 'cd /workspace && ansible-playbook playbooks/site.yml'

lint: lint-ansible lint-dockerfiles lint-shell

lint-ansible:
	$(CONTROLLER_EXEC) 'cd /workspace && yamllint . && ansible-lint playbooks/site.yml'

lint-dockerfiles:
	docker run --rm -v "$(PWD)":/workspace -w /workspace --entrypoint hadolint $(HADOLINT_IMAGE) controller/Dockerfile ubuntu/Dockerfile alpine/Dockerfile rocky/Dockerfile

lint-shell:
	docker run --rm -v "$(PWD)":/workspace -w /workspace --entrypoint shellcheck $(SHELLCHECK_IMAGE) script/bootstrap.sh script/entrypoint.sh

scan:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock $(TRIVY_IMAGE) image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 0 anslab/controller
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock $(TRIVY_IMAGE) image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 0 anslab/ubuntu
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock $(TRIVY_IMAGE) image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 0 anslab/alpine
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock $(TRIVY_IMAGE) image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 0 anslab/rocky

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --remove-orphans --volumes
