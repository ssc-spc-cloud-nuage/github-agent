#!/bin/bash -e
################################################################################
##  File:  azcopy.sh
##  Desc:  Installs AzCopy
################################################################################

# Install AzCopy10
wget -O /tmp/azcopy.tar.gz https://aka.ms/downloadazcopy-v10-linux
tar zxvf /tmp/azcopy.tar.gz --strip-components=1 -C /tmp
mv /tmp/azcopy /usr/local/bin/azcopy
chmod +x /usr/local/bin/azcopy
