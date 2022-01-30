From lsiobase/alpine:3.15

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
	apk add --no-cache postfix cyrus-sasl rsync opendkim opendkim-utils ca-certificates

EXPOSE 25

VOLUME /config
