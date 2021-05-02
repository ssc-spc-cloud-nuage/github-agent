#!/bin/bash
# Github Runned stuff

if [[ "$@" == "bash" ]]; then
    exec $@
fi

if [[ -z $RUNNER_REPO_URL && -z $RUNNER_ORG_URL ]]; then
    echo "Error : You need to set the RUNNER_REPO_URL (or RUNNER_ORG_URL) environment variable."
    exit 1
fi

if [[ -z $RUNNER_TOKEN && -z $GITHUB_TOKEN ]]; then
    echo "Error : You need to set RUNNER_TOKEN (or GITHUB_TOKEN) environment variable."
    exit 1
fi

if [[ -f ".runner" ]]; then
    echo "Runner already configured. Skipping config."
else

    if [[ ! -z $RUNNER_ORG_URL ]]; then
        SCOPE="orgs"
        RUNNER_URL="${RUNNER_ORG_URL}"
    else
        SCOPE="repos"
        RUNNER_URL="${RUNNER_REPO_URL}"
    fi

    if [[ -n $GITHUB_TOKEN ]]; then
        echo "Exchanging the GitHub Access Token for a Runner Token (scope: ${SCOPE})..."

        _PROTO="$(echo "${RUNNER_URL}" | grep :// | sed -e's,^\(.*://\).*,\1,g')"
        _URL="$(echo "${RUNNER_URL/${_PROTO}/}")"
        _PATH="$(echo "${_URL}" | grep / | cut -d/ -f2-)"    

        RUNNER_TOKEN=$(curl -s -X POST -H "authorization: token ${GITHUB_TOKEN}" "https://api.github.com/${SCOPE}/${_PATH}/actions/runners/registration-token" | jq -r .token)
    fi

    ./config.sh \
        --url "${RUNNER_URL}" \
        --token "${RUNNER_TOKEN}" \
        --name "${RUNNER_NAME}" \
        --unattended \
        --replace \
        --work _work
fi

# DIND stuff
source /opt/bash-utils/logger.sh

function wait_for_process () {
    local max_time_wait=30
    local process_name="$1"
    local waited_sec=0
    while ! pgrep "$process_name" >/dev/null && ((waited_sec < max_time_wait)); do
        INFO "Process $process_name is not running yet. Retrying in 1 seconds"
        INFO "Waited $waited_sec seconds of $max_time_wait seconds"
        sleep 1
        ((waited_sec=waited_sec+1))
        if ((waited_sec >= max_time_wait)); then
            return 1
        fi
    done
    return 0
}

INFO "Starting supervisor"
/usr/bin/supervisord -n >> /dev/null 2>&1 &

INFO "Waiting for processes to be running"
processes=(dockerd)

for process in "${processes[@]}"; do
    wait_for_process "$process"
    if [ $? -ne 0 ]; then
        ERROR "$process is not running after max time"
        exit 1
    else 
        INFO "$process is running"
    fi
done

exec "$@"

sleep infinity