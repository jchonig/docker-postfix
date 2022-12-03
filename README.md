# docker-postfix
A container running postfix intended to be used as an internal mail
relay to the outside world.

Optionally authenticate incoming connections with SASL

# Usage

## docker

```
docker create \
  --name=posfix \
  -e PUID=1000 \
  -e PGID=1000 \
  -v </path/to/appdata/config>:/config \
  -p 25:25 \
  --restart unless-stopped \
  jchonig/postfix
```

### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  postfix:
    image: jchonig/postfix
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - </path/to/appdata/config>:/config
	  - data:/data
    port:
      - 25
    restart: unless-stopped

volumes:
  data:
```

# Parameters

## Ports (-p)

| Volume | Function               |
| ------ | --------               |
| 25     | The incoming SMTP port |

## Environment Variables (-e)

| Env                            | Function                                                     |
| ---                            | --------                                                     |
| PUID=1000                      | for UserID - see below for explanation                       |
| PGID=1000                      | for GroupID - see below for explanation                      |
| USE_SASL=yes                   | Use sasl for user authentication                             |
| USE_SASLAUTHD=yes              | Use saslauthd                                                |
| USE_DKIM=yes                   | Not yet implemented                                          |
| USE_TLS=yes                    | Enable TLS for incoming connectinos                          |
| MYHOSTNAME=example.com         | Configure postfix myhostname parameter                       |
| MYORIGIN=example.com           | Configure postfix myorigin parameter                         |
| MYDESTINATION=                 | Configure postfix mydestination parameter                    |
| MASQUERADE_DOMAINS=example.com | A comma seperated list of domains to masquerade              |
| SMTPD_TLS_SECURITY_LEVEL=may   | Configure the level of TLS required on incomming connections |
| BOUNCE_QUEUE_LIFETIME=1d       | Configure the postfix bounce queue lifetime                  |

## Volume Mappings (-v)

| Volume  | Function                           |
|---------|------------------------------------|
| /data   | Persistent data (i.e. /data/spool) |
| /config | All the config files reside here   |


# Application Setup

+ When USE_TLS is enabled, /config/server.cert and /config/server.key should exist
  + When these files are updated, postfix is reloaded automatically
+ When using SASL, /config/sasl.users should should have one entry per line of user and password seperated by a space
  + WHen this file is updated, *update_sasldb_users* is run automatically
+ Additonal postfix configuration can be stored in /config/postconf and /config/postconf.d/*
  + These files contain arguments to the postconf command
  + These files are processed when the container starts
  + These files are reparsed automatically when they are modified or created
  + The files in /config/postconf.d are not processed in a particular order
+ Aliases are stored in /config/aliases
  + If this file does not exists the default postfix file is copied to it
  + When this file is updated, *newaliases* is run

## TODO

+ [ ] Set up DKIM
+ [ ] Read and process generics and virtual?
...
