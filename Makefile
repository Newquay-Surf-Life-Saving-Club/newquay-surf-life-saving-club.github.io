include .env

SHELL = /bin/sh

CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

.PHONY: run run-bash new-react-app aider aider-example-ask-data-sources aider-architect aider-open-ai-list

all: run

aider:
	docker run -it --user ${CURRENT_UID}:${CURRENT_GID} --volume ${PWD}:/app paulgauthier/aider-full --model sonnet --anthropic-api-key "${ANTHROPIC_API_KEY}"

aider-open-ai-list:
	docker run -it --user ${CURRENT_UID}:${CURRENT_GID} --volume ${PWD}:/app paulgauthier/aider-full --model sonnet --api-key openai="${OPENAI_API}" --list-models openai/

aider-architect:
	docker run -it --user ${CURRENT_UID}:${CURRENT_GID} --volume ${PWD}:/app paulgauthier/aider-full --model o1 --editor-model sonnet --api-key anthropic="${ANTHROPIC_API_KEY}" --api-key openai="${OPENAI_API}" --architect


run:
	hugo server --buildDrafts

build:
	hugo --environment production --minify

update-theme:
	hugo mod get -u
	hugo mod tidy
