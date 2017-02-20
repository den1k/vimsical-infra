.PHONY: .vault_passs env inventory

# ------------------------------------------------------------------------------
# System deps
# Run this targets to install dependencies on driver machine

# NOTE DO NOT install ansible with brew!

install-linux:
	sudo apt-get install python python-pip
	sudo pip install ansible==2.2 boto

install-mac:
	brew install awscli
	sudo easy_install pip
	sudo pip install ansible==2.2 boto

# ------------------------------------------------------------------------------
# Vault

.vault_passs:
	echo "ERROR: missing .vault_pass file"
	echo "HINT: echo \"secret_password\" > .vault_pass"
	exit 1

# ------------------------------------------------------------------------------
# Environment

env:
ifndef env
	$(error "usage: make <target> env=foo")
endif
	@echo "Running with environment: $(env)"

# ------------------------------------------------------------------------------
# Ansible config

# BUG: https://github.com/ansible/ansible/issues/16857
root_dir:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
dynamic_inventory_file := $(root_dir)/inventory/ec2.py

flags := -v -i $(dynamic_inventory_file)

extra-vars := \
--extra-vars dynamic_inventory_file=$(dynamic_inventory_file) \
--extra-vars env_name=$(env) \
-e @env.yml \
-e @secrets.yml

# ------------------------------------------------------------------------------
# Targets

destroy: env
	ansible-playbook playbooks/destroy.yml $(flags) $(extra-vars) --tags "destroy"

provision: env
	ansible-playbook playbooks/provision.yml $(flags) $(extra-vars) --tags "provision"

configure: env
	ansible-playbook playbooks/configure.yml $(flags) $(extra-vars) --tags "configure"

deploy: env
	ansible-playbook playbooks/deploy.yml $(flags) $(extra-vars) --tags "deploy"


all: .vault_pass env provision configure deploy
