From lsiobase/alpine:3.20

ENV \
	USE_SASL= \
        USE_SASLAUTHD=no \
	USE_DKIM= \
	USE_TLS= \
	MYHOSTNAME= \
	MYORIGIN= \
	MYDESTINATION= \
        MASQUERADE_DOMAINS= \
        SMTPD_TLS_SECURITY_LEVEL= \
	BOUNCE_QUEUE_LIFETIME=

# Add configuration files
COPY root /

# Set up
RUN \
    echo "*** Install required packages ****" && \
    apk add --no-cache postfix \
        postfix-doc \
        cyrus-sasl \
        rsync \
        opendkim \
        opendkim-utils \
        inotify-tools \
        ca-certificates

EXPOSE 25
EXPOSE 465

VOLUME /config
