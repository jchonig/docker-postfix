TAG=devel
IMAGE=postfix
VOLUMES= \
    -v ${PWD}/config:/config
ENV= \
    -e USE_SASL=yes \
    -e USE_SASLAUTHD=yes \
    -e USE_TLS=yes \
    -e MYHOSTNAME=home.honig.net \
    -e MYORIGIN=honig.net \
    -e MASQUERADE_DOMAINS=honig.net \
    -e SMTPD_TLS_SECURITY_LEVEL=may \
    -e BOUNCE_QUEUE_LIFETIME=1d
PORTS= \
    -p 25:25

all: build

clean:
	find . -name \*~ -delete

run: build
	docker run ${VOLUMES} ${ENV} ${PORTS} -it ${IMAGE}:${TAG}

sasl_users: build
	docker run ${VOLUMES} ${ENV} ${PORTS} -it ${IMAGE}:${TAG} sasl_users

# Run the container with just a bash shell
run-bash: build
	docker run ${VOLUMES} ${ENV} ${PORTS} -it --entrypoint /bin/bash ${IMAGE}:${TAG}

# Start the container and run a bash shell
exec-bash: build
	docker run ${VOLUMES} ${ENV} ${PORTS} -it ${IMAGE}:${TAG} /bin/bash

build: true
	docker build -t ${IMAGE}:${TAG} .

true: ;
