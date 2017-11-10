REPOSITORY?=panta/td-agent
TAG?=secure-and-sql

OK_COLOR=\033[32;01m
NO_COLOR=\033[0m

.PHONY: all
all: build push

.PHONY: build
build:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Building $(REPOSITORY):$(TAG)"
	@docker build --rm -t $(REPOSITORY):$(TAG) .

$(REPOSITORY)_$(TAG).tar: build
	@echo "$(OK_COLOR)==>$(NO_COLOR) Saving $(REPOSITORY):$(TAG) > $@"
	@docker save $(REPOSITORY):$(TAG) > $@

.PHONY: push
push: build
	@echo "$(OK_COLOR)==>$(NO_COLOR) Pushing $(REPOSITORY):$(TAG)"
	@docker push $(REPOSITORY):$(TAG)
