# Importar configuracion.
# Puedes cambiar la configuracion por defecnto mediante `make cnf="config_special.env" build`
cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# HELP
# Esto sera la salida de ayuda para cada task
.PHONY: help

help: ## Esta ayuda.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Construir contenedores 
build: ## Crea la imagen del contenedor
	docker build -t $(APP_NAME) .

run: ## Ejecuta el contenedor en el puerto configurador en `config.env` 
	docker run -i -t --rm --env-file=./config.env -p=$(PORT):80 --name="$(APP_NAME)" $(APP_NAME)

rund: ## Ejecuta el contenedor en el puerto configurador en `config.env` como demonio
	docker run -d --env-file=./config.env -p=$(PORT):80 --name="$(APP_NAME)" $(APP_NAME)

stop: ## Para y elimina el contenedor que este en ejecucion
	docker stop $(APP_NAME); docker rm $(APP_NAME)

# Docker publish
publish: repo-login publish-latest publish-version ## Publica la imagen tageada tanto con `{version}` como `latest` 

publish-latest: tag-latest ## Publica la imagen con tag `latest`
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publica la imagen con tag `{version}`
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Asigna el tag `{version}` a la imagen
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Asigna el tag `latest` a la imagen
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

test1: build rund ## Ejecuta test
	./test1.sh

# HELPERS
CMD_REPOLOGIN := "docker login -u${USUARIO} -p ${DOCKER_REPO}"

# login to AWS-ECR
repo-login: ## login
	@eval $(CMD_REPOLOGIN)

version: ## Muestra la version 
	@echo $(VERSION)
	


