.PHONY: .vault_passs env deps inventory

# ------------------------------------------------------------------------------
# System deps
# Run this targets to install dependencies on driver machine

# NOTE DO NOT install ansible with brew!

deps-mac:
	brew install awscli
	sudo easy_install pip
	sudo pip install ansible boto

deps: deps-mac

# ------------------------------------------------------------------------------
# Vault

.vault_passs:
	echo "ERROR: missing .vault_pass file"
	echo "HINT: echo \"secret_password\" > .vault_pass"
	exit 1

# ------------------------------------------------------------------------------
# Environment

args:
ifndef env_name
	$(error "usage: make <target> env_name=foo")
endif
	@echo "Running with environment: $(env_name)"


env-error = $(error "ERROR: AWS cli is not configured: run `aws configure` and retry.")
AWS_ACCESS_KEY_ID := $(shell aws configure get aws_access_key_id)
AWS_SECRET_ACCESS_KEY := $(shell aws configure get aws_secret_access_key)
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

env-vars:
ifndef AWS_ACCESS_KEY_ID
	$(call env-error)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(call env-error)
endif

env: args env-vars

# ------------------------------------------------------------------------------
# Ansible

# Config

# BUG: https://github.com/ansible/ansible/issues/16857
root_dir:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
dynamic_inventory_file := $(root_dir)/inventory/ec2.py

flags := -v -i $(dynamic_inventory_file)

extra-vars := \
--extra-vars dynamic_inventory_file=$(dynamic_inventory_file) \
--extra-vars env_name=$(env_name) \
--extra-vars AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
--extra-vars AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)

# Targets

destroy: env
	ansible-playbook playbooks/destroy.yml $(flags) $(extra-vars) --tags "destroy"

provision: env
	ansible-playbook playbooks/provision.yml $(flags) $(extra-vars) --tags "provision"

configure: env
	ansible-playbook playbooks/configure.yml $(flags) $(extra-vars) --tags "configure"

all: .vault_pass env provision configure
