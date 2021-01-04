#!/usr/bin/env bash
set -eEuo pipefail

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

exec "$@"