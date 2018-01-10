DOCKREG=docker.iot.bzh
NAME=jenkins
VERSION=$(shell ls -d images/$(NAME)/* | sort -rn | head -1 | xargs basename )
REPO=iotbzh
IMAGE_NAME=$(DOCKREG)/$(REPO)/$(NAME):$(VERSION)
IMAGE_LATEST=$(DOCKREG)/$(REPO)/$(NAME):latest
IMAGE_DIR=images/$(NAME)/$(VERSION)
CNAME=vm-$(NAME)

RUN_EXTRA_ARGS=

######################### the steps are done outside the container #######################

help: 
	@echo "Available targets:"
	@echo "- clean: drop existing container and image"
	@echo "- distclean: drop temp images (the one produced by a bad Dockerfile...)"
	@echo "- build: create new image"
	@echo "- test: start a new test container and enter in it. After exit, the container is destoyed"
	@echo "- export: export the image to a compressed archive"
	@echo "- export-latest: export the latest image to a compressed archive"
	@echo ""
	@echo "Images available for build (NAME):"
	@find images -mindepth 1 -maxdepth 1 -type d | xargs -n 1 basename | awk '{printf("- %s\n",$$1);}'
	@echo ""
	@echo "Variables:"
	@echo "- Docker registry:           DOCKREG=$(DOCKREG)"
	@echo "- Image name:                NAME=$(NAME)"
	@echo "- Image version:             VERSION=$(VERSION)"
	@echo "- Container name/host name:  CNAME=$(CNAME)"
	@echo "- Extra args to 'docker run': RUN_EXTRA_ARGS=$(RUN_EXTRA_ARGS)"
	@echo
	@echo "Containers:"
	@docker ps -a
	@echo
	@echo "Images:"
	@docker images
	@echo
	@echo "Typical usage:"
	@echo "- build an image: make build NAME=myimage"
	@echo "- build and export: make build export NAME=myimage"
	@echo "- build, test and export: make build test export NAME=myimage"
	@echo


.PHONY:clean
clean: 
	@docker inspect $(CNAME) &>/dev/null && { \
		echo "Stopping and removing container $(CNAME)" ; \
		docker stop $(CNAME) || true; \
		docker rm $(CNAME); \
	} || true
	@docker inspect $(IMAGE_NAME) &>/dev/null && { \
		echo "Removing image $(IMAGE_NAME)"; \
		docker rmi $(IMAGE_NAME) ; \
	} || true
	@rm -fv images/*/*/wait_for_net.sh

# remove spurious containers and images left by broken builds
.PHONY:distclean
distclean: clean
	docker rmi $$(docker images | grep "^<none>" | awk '{print $$3}')

.PHONY:build 
build: 
	@cp wait_for_net.sh $(IMAGE_DIR)
	@echo "------------------- Building image $(NAME) -------------------"; \
	[ -f $(IMAGE_DIR)/Makefile ] && $(MAKE) -C $(IMAGE_DIR) build || true
	docker build --no-cache=true --rm --pull -t $(IMAGE_NAME) $(IMAGE_DIR) # build the image
	[ -f $(IMAGE_DIR)/Makefile ] && $(MAKE) -C $(IMAGE_DIR) clean || true
	@rm -fv $(IMAGE_DIR)/wait_for_net.sh
	docker images

.PHONY:test
test:
	docker run --detach=true --net=none --hostname=$(CNAME) --name=$(CNAME) \
		--privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -it $(RUN_EXTRA_ARGS) $(IMAGE_NAME)
	./docker-netstart $(CNAME)
	docker exec -it $(CNAME) /bin/bash || true
	docker stop $(CNAME) || true
	docker rm $(CNAME) || true

.PHONY:export
export:
	@echo "Export image to $(REPO)_$(NAME)-$(VERSION).tar.xz"
	docker save $(IMAGE_NAME) | xz -T0 -c >docker_$(REPO)_$(NAME)-$(VERSION).tar.xz

.PHONY:export-latest
export-latest:
	@echo "Export image to $(REPO)_$(NAME)-latest.tar.xz"
	docker save $(IMAGE_LATEST) | xz -T0 -c >docker_$(REPO)_$(NAME)-latest.tar.xz

