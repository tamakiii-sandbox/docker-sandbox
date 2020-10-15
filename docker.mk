.PHONY: setup dependencies list clean

PREFIX := tamakiii-sandbox/docker-sandbox
DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
TYPES := $(patsubst $(basename $(DIR))/%.dockerfile,%,$(wildcard $(DIR)/*.dockerfile))
TARGETS := $(shell echo $(wildcard $(DIR)/*.dockerfile) | xargs grep -e 'FROM' -e 'AS' | awk '{ print $$4 }')

setup: \
	dependencies

dependencies:
	@type docker > /dev/null

list:
	@echo $(foreach y,$(TYPES),$(foreach t,$(TARGETS),$y/$t))

# build/$(TYPES)/$(TARGETS)
$(addprefix build/,$(foreach y,$(TYPES),$(foreach t,$(TARGETS),$y/$t))):
	docker build \
		-t $(PREFIX)/$(word 2,$(subst /, ,$@))/$(word 3,$(subst /, ,$@)) \
		-f $(DIR)/$(word 2,$(subst /, ,$@)).dockerfile \
		--target $(word 3,$(subst /, ,$@)) \
		.

# bash/$(TYPES)/$(TARGETS)
$(addprefix bash/,$(foreach y,$(TYPES),$(foreach t,$(TARGETS),$y/$t))):
	docker run \
		-it \
		--rm \
		--volume $(shell pwd):/work \
		--workdir /work \
		$(PREFIX)/$(word 2,$(subst /, ,$@))/$(word 3,$(subst /, ,$@)) \
		$(word 1,$(subst /, ,$@))

clean:
	docker image rm $(foreach y,$(TYPES),$(foreach t,$(TARGETS),$(PREFIX)/$y/$t))
