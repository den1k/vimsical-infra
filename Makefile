.PHONY: .vault_passs env inventory


# ------------------------------------------------------------------------------
# System deps for the driver machine

# NOTE DO NOT install ansible with brew!

install-linux:
	sudo apt-get install python python-pip
	sudo pip install ansible==2.3 boto boto3
	sudo ansible-galaxy install Datadog.datadog

install-mac:
	brew install awscli
	sudo easy_install pip
	sudo pip install ansible==2.3 boto boto3
	sudo ansible-galaxy install Datadog.datadog

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
-e @./env/$(env).yml \
-e @env.yml \
-e @secrets.yml


# ------------------------------------------------------------------------------
# Targets

bastion: env
	ansible-playbook playbooks/bastion.yml $(flags) $(extra-vars) --tags "provision,bastion"

# destroy: env
# 	ansible-playbook playbooks/destroy.yml $(flags) $(extra-vars) --tags "destroy"

provision: env
	ansible-playbook playbooks/provision.yml $(flags) $(extra-vars) --tags "provision"

configure: env
	ansible-playbook playbooks/configure.yml $(flags) $(extra-vars) --tags "configure"

build: env
	ansible-playbook playbooks/build.yml $(flags) $(extra-vars) --tags "frontend,backend"

deploy: env
	ansible-playbook playbooks/deploy.yml $(flags) $(extra-vars) --tags "frontend,backend"

web: env
	ansible-playbook playbooks/build.yml $(flags) $(extra-vars) --tags "frontend"
	ansible-playbook playbooks/deploy.yml $(flags) $(extra-vars) --tags "frontend"

tunnel-start: env
	ansible-playbook playbooks/tunnel_start.yml $(flags) $(extra-vars)

tunnel-stop: env
	ansible-playbook playbooks/tunnel_stop.yml $(extra-vars)

all: .vault_pass env provision configure build deploy
