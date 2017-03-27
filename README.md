# Overview

## Usage

```
make <target> env=<target env name>
```

## Provisioning
## Configuration
## Deployment

# Admin tasks
## SSH into a machine

The provisioning playbooks saves the keypairs to the machine running ansible, in `~/.ssh/<env>.pem`

```sh
ssh -i ~/.ssh/<env>.pem ubuntu@<ec2_ip>
```

## Datomic (transactor)

Runs as a systemd unit in `/etc/systemd/system/datomic-transactor.service`

### Config

`DATOMIC_HOME` is in `/var/datomic/`.


## Cassandra

### Config

We use the default configuration directory and path: `/etc/cassandra/cassandra.yml`

### Health check

Get a status of the cluster with

```sh
nodetool status
```

## API

### Config

The API jar runs as a systemd unit, located in `/etc/systemd/system/vimsica-api.service`

### Logs

```sh
journalctl -u vimsical-api.service
```

# TODOs


