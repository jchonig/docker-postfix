# docker-postfix

A container running postfix intended to be used as an internal mail
relay to the outside world.

Image hosted at: `ghcr.io/jchonig/postfix`

Optionally authenticate incoming connections with SASL

## Usage

### docker

```sh
docker create \
  --name=postfix \
  -e PUID=1000 \
  -e PGID=1000 \
  -v </path/to/appdata/config>:/config \
  -p 25:25 \
  --restart unless-stopped \
  ghcr.io/jchonig/postfix
```

### docker-compose

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2"
services:
  postfix:
    image: ghcr.io/jchonig/postfix
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

## Parameters

### Ports (-p)

| Port | Function               |
| ---- | ---------------------- |
| 25   | The incoming SMTP port |

### Environment Variables (-e)

- `PUID=1000`: for UserID
- `PGID=1000`: for GroupID
- `USE_SASL=yes`: use SASL for user authentication
- `USE_SASLAUTHD=yes`: use saslauthd
- `USE_DKIM=yes`: not yet implemented
- `USE_TLS=yes`: enable STARTTLS for incoming connections on port 25
- `USE_SMTPS=yes`: enable the TLS wrapper on port 465
- `MYHOSTNAME=example.com`: postfix `myhostname`
- `MYORIGIN=example.com`: postfix `myorigin`
- `MYDESTINATION=`: postfix `mydestination`
- `MASQUERADE_DOMAINS=example.com`: a comma separated list of domains
  to masquerade
- `SMTPD_TLS_SECURITY_LEVEL=may`: the level of TLS required on incoming
  connections
- `BOUNCE_QUEUE_LIFETIME=1d`: postfix `bounce_queue_lifetime`
- `INET_PROTOCOLS=all`: postfix `inet_protocols` (`all`, `ipv4` or
  `ipv6`)
- `RELAYHOST=[host]:port`: outbound relay host, for example
  `[smtp-relay.gmail.com]:587`

### Volume Mappings (-v)

| Volume  | Function                           |
| ------- | ---------------------------------- |
| /data   | Persistent data (i.e. /data/spool) |
| /config | All the config files reside here   |

## Application Setup

- When `USE_TLS` is enabled, `/config/server.cert` and
  `/config/server.key` should exist
  - When these files are updated, postfix is reloaded automatically
  - Optionally, `/config/server-rsa.cert` and `/config/server-rsa.key`
    add an RSA certificate alongside an ECDSA `server.cert`, for clients
    that only support RSA cipher suites (such as some printers); postfix
    picks the certificate that matches the client
  - The RSA pair is only used when both files exist and the key matches
    the certificate; it is picked up or dropped automatically when the
    files change
- When `RELAYHOST` is set, outbound TLS (`smtp_tls_security_level=encrypt`)
  is enabled automatically
  - Relay credentials are read from `/config/sasl.passwd`, which uses
    standard postfix `sasl_passwd` format: one entry per line of
    `relayhost user:password`
  - Example: `[smtp-relay.gmail.com]:587 you@yourdomain.com:app-password`
  - `/config/sasl.passwd` is read directly by postfix on demand — no
    rebuild step needed when the file changes
  - For Gmail Workspace: set `RELAYHOST=[smtp-relay.gmail.com]:587` and
    generate an
    [App Password](https://support.google.com/accounts/answer/185833)
    for the account; enable the SMTP relay service in Google Workspace
    Admin → Apps → Gmail → Routing
- When using SASL, `/config/sasl.users` should have one entry per line of
  user and password separated by a space
  - When this file is updated, `update_sasldb_users` is run automatically
- Additional postfix configuration can be stored in `/config/postconf`
  and `/config/postconf.d/*`
  - These files contain arguments to the postconf command
  - These files are processed when the container starts
  - These files are reparsed automatically when they are modified or
    created
  - The files in `/config/postconf.d` are not processed in a particular
    order
- Aliases are stored in `/config/aliases`
  - If this file does not exist the default postfix file is copied to it
  - When this file is updated, `newaliases` is run

## TODO

- [ ] Set up DKIM
- [ ] Read and process generics and virtual?
