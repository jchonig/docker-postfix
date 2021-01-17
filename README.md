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
    port:
      - 25
    restart: unless-stopped
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

| Volume  | Function                         |
| ------  | --------                         |
| /config | All the config files reside here |

# Application Setup

+ When USE_TLS is enabled, /config/server.cert and /config/server.key should must exist
+ When using SASL, /config/sasl.users should should have one entry 	per line of user and password seperated by a space
+ When using SASL, run *update_sasldb_users when that file is updated
+ When using SASL, a bug in Alpine 3.13 requires USE_SASLAUTHD=yes
+ Additonal postfix configuration can be stored in /config/postconf as arguments to the postconf command

## TODO

+ [ ] Set up DKIM
+ [ ] Logging is to stdout, should it be to a log file with rotation?
+ [ ] How to maintain aliases and other database files?
...
