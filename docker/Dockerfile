FROM ubuntu:20.04

ENV RUNNER_VERSION=2.275.1

RUN apt-get -yqq update && apt-get install -yqq curl jq wget software-properties-common supervisor 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf

WORKDIR /home/runner

RUN RUNNER_VERSION=${RUNNER_VERSION:-$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && curl -L -O https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar -zxf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm -f actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

COPY ./tools ./tools \
RUN chown -R root: /home/runner \
    && ./bin/installdependencies.sh \
    && ./tools/installtools.sh \    
    && rm -rf ./tools

COPY ./entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]