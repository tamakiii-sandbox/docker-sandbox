.PHONY: setup dependencies vars clean

NAME := tamakiii-sandbox/docker-sandbox
DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
TYPES := $(patsubst $(basename $(DIR))/%.dockerfile,%,$(wildcard $(DIR)/*.dockerfile))
TARGETS := $(shell echo $(wildcard $(DIR)/*.dockerfile) | xargs grep -e 'FROM' -e 'AS' | awk '{ print $$4 }')

setup: \
	dependencies

dependencies:
	@type docker > /dev/null

vars:
	@echo DIR=$(DIR)
	@echo TYPE=$(TYPES)
	@echo TARGETS=$(TARGETS)

# build/$(TYPE)/$(TARGET)
$(addprefix build/,$(foreach y,$(TYPES),$(foreach t,$(TARGETS),$y/$t))):
	docker build \
		-t $(NAME)/$(word 2,$(subst /, ,$@)) \
		-f $(word 2,$(subst /, ,$@)).dockerfile \
		--target $(word 3,$(subst /, ,$@)) \
		.

# bash/$(TYPE)
$(addprefix bash/,$(foreach y,$(TYPES),$y)):
	docker run \
		-it \
		--rm \
		--volume $(shell pwd):/work \
		--workdir /work \
		$(NAME)/$(word 2,$(subst /, ,$@)) \
		$(word 1,$(subst /, ,$@))

clean:
	$(foreach y,$(TYPES),docker image rm $(NAME)/$(TYPES))
