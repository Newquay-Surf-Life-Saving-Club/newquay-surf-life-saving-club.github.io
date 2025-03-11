include .env

SHELL = /bin/sh

CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

.PHONY: run run-bash new-react-app aider aider-example-ask-data-sources aider-architect aider-open-ai-list

all: run

aider:
	docker run -it --user ${CURRENT_UID}:${CURRENT_GID} --volume ${PWD}:/app paulgauthier/aider-full --model sonnet --anthropic-api-key "${ANTHROPIC_API_KEY}"

aider-example-ask-data-sources:
	@echo "Prompt: /ask List the fields for DataSource entities." && \
	docker run -it --user ${CURRENT_UID}:${CURRENT_GID} --volume ${PWD}:/app paulgauthier/aider-full --model sonnet --anthropic-api-key "${ANTHROPIC_API_KEY}" app/src/components/DataSources.js app/src/components/DataSources.jsx

aider-open-ai-list:
	docker run -it --user ${CURRENT_UID}:${CURRENT_GID} --volume ${PWD}:/app paulgauthier/aider-full --model sonnet --api-key openai="${OPENAI_API}" --list-models openai/

aider-architect:
	docker run -it --user ${CURRENT_UID}:${CURRENT_GID} --volume ${PWD}:/app paulgauthier/aider-full --model o1 --editor-model sonnet --api-key anthropic="${ANTHROPIC_API_KEY}" --api-key openai="${OPENAI_API}" --architect

# app:
# 	mkdir app

# new-react-app: app
# 	docker run --user ${CURRENT_UID}:${CURRENT_GID} --rm --name neb-create-react-app -it -p 8080:8080 -v ${PWD}:/project neb-create-react-app:latest yarn create react-app app

# run-bash:
# 	docker run --user ${CURRENT_UID}:${CURRENT_GID} --rm --name neb-create-react-app -it -p 8080:8080 -v ${PWD}/app:/project neb-create-react-app:latest /bin/bash

# run:
# 	docker run --user ${CURRENT_UID}:${CURRENT_GID} --rm --name neb-create-react-app -it -p 8080:8080 -v ${PWD}/app:/project neb-create-react-app:latest npm run dev -- --host


run:
	hugo server --buildDrafts

build:
	hugo --environment production --minify

update-theme:
	hugo mod get -u
	hugo mod tidy

git-set-local-config:
	git config user.name "Ben Whorwood" && git config user.email "code@mube.uk"


docker-build:
	docker build -t unity-api-ui-console:latest .

docker-run:
	docker run --rm --name unity-api-ui-console -it -p 8080:80 unity-api-ui-console:latest

DOCKER_TAG = 1.0.11

docker-tag:
	docker tag unity-api-ui-console:latest flowmoco/unity-api:unity-ui-console-$(DOCKER_TAG)

docker-push:
	docker push flowmoco/unity-api:unity-ui-console-$(DOCKER_TAG)

docker-deploy: docker-tag docker-push

docker-run-shell:
	docker run --rm --name unity-api-ui-console -it -p 8080:80 unity-api-ui-console:latest /bin/sh

k8s-deploy:
	kubectl -n unity-api apply -f deploy/dev/Deployment.yaml
