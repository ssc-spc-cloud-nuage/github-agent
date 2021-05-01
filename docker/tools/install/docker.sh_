#!/bin/bash -e
################################################################################
##  File:  docker.sh
##  Desc:  Installs Docker
################################################################################

curl -fsSL https://get.docker.com -o- | sh

# Run tests to determine that the software installed as expected
echo "Testing to make sure that script performed as expected"
if ! command -v docker; then
    echo "docker was not installed"
    exit 1
fi