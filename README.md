# TODOS

- Accept API SSL cert
- Update alb conf to use new cert
- Re-enable http on cloudfront
- Enable website hosting on audio bucket
- Fix audio bucket cors

NOTE: exact origin and no *

<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>https://vimsical.com</AllowedOrigin>
        <AllowedOrigin>http://vimsical.com</AllowedOrigin>
        <AllowedMethod>POST</AllowedMethod>
        <AllowedMethod>GET</AllowedMethod>
        <ExposeHeader>ETag</ExposeHeader>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
</CORSConfiguration>

- Whitelist origin header on cors distribution
- Fix CORS permissions on web bucket? (font)


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


