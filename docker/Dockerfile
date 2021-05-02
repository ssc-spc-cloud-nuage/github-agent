FROM ubuntu:20.04

ENV RUNNER_VERSION=2.275.1

ENV DOCKER_CHANNEL=stable \
	DOCKER_VERSION=20.10.6 \
	DEBUG=false

ENV RUNNER_NAME=""
ENV RUNNER_TOKEN=""
ENV RUNNER_REPO_URL=""
ENV RUNNER_ORG_URL=""
ENV RUNNER_TOKEN=""
ENV RUNNER_ALLOW_RUNASROOT=true
ENV GITHUB_TOKEN=""

RUN apt-get -yqq update \
    && apt-get install -yqq curl jq wget software-properties-common supervisor \
    ca-certificates openssh-client iptables sudo

# Docker installation
RUN set -eux; \
	\
	arch="$(uname --m)"; \
	case "$arch" in \
        # amd64
		x86_64) dockerArch='x86_64' ;; \
        # arm32v6
		armhf) dockerArch='armel' ;; \
        # arm32v7
		armv7) dockerArch='armhf' ;; \
        # arm64v8
		aarch64) dockerArch='aarch64' ;; \
		*) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;;\
	esac; \
	\
	if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
		echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
		exit 1; \
	fi; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	dockerd --version; \
	docker --version

COPY modprobe startup.sh /usr/local/bin/
COPY supervisord.conf /etc/supervisor/conf.d/
COPY logger.sh /opt/bash-utils/logger.sh

# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /usr/local/bin/startup.sh /usr/local/bin/modprobe
VOLUME /var/lib/docker

# Github actions runner installation
WORKDIR /home/runner

RUN RUNNER_VERSION=${RUNNER_VERSION:-$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && curl -L -O https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar -zxf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm -f actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Actions tools installation

COPY ./tools ./tools
RUN chown -R root: /home/runner \
    && ./bin/installdependencies.sh \
    && ./tools/installtools.sh \    
    && rm -rf ./tools

# COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/local/bin/startup.sh"]
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]