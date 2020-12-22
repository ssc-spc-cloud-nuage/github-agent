FROM ubuntu:20.04

ENV RUNNER_VERSION=2.275.1

RUN apt-get -yqq update && apt-get install -yqq curl jq wget software-properties-common supervisor 

RUN \
  LABEL="$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')" \
  RUNNER_VERSION="$(echo ${latest_version_label:1})" \
  mkdir -p /home/actions/actions-runner \
    && cd /home/actions/actions-runner \
    && wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf

WORKDIR /home/actions/actions-runner

COPY ./tools ./tools
RUN /home/actions/actions-runner/bin/installdependencies.sh \
    && /home/actions/actions-runner/tools/installtools.sh \    
    && rm -rf /home/actions/actions-runner/tools

COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]