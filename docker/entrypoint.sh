#!/usr/bin/env bash
set -eEuo pipefail

if [[ "$@" == "bash" ]]; then
    exec $@

elif [[ -f ".runner" ]]; then
    echo "Runner already configured. Skipping config."

else

  TOKEN=$(curl -s -X POST -H "authorization: token ${GITHUB_TOKEN}" "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/actions/runners/registration-token" | jq -r .token)

  ./config.sh \
    --url "https://github.com/${REPO_OWNER}/${REPO_NAME}" \
    --token "${TOKEN}" \
    --name "${RUNNER_NAME}" \
    --unattended \
    --work _work

fi

exec "$@"