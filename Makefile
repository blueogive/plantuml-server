.PHONY : docker-prune docker-check docker-build docker-push

# VCS_URL := $(shell git remote get-url --push gh)
# VCS_REF := $(shell git rev-parse --short HEAD)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
TAG_DATE := $(shell date -u +"%Y%m%d")
REGISTRY_USER := blueogive
IMG_NAME := plantuml-server

docker-prune :
	@echo Pruning Docker images/containers/networks not in use
	docker system prune

docker-check :
	@echo Computing reclaimable space consumed by Docker artifacts
	docker system df

docker-build: Dockerfile.jetty pom.xml
	@docker build -f $< \
	--tag $(REGISTRY_USER)/$(IMG_NAME):$(TAG_DATE) \
	--tag $(REGISTRY_USER)/$(IMG_NAME):latest .

docker-push : docker-build
	@docker push $(REGISTRY_USER)/$(IMG_NAME):$(TAG_DATE)
	@docker push $(REGISTRY_USER)/$(IMG_NAME):latest
