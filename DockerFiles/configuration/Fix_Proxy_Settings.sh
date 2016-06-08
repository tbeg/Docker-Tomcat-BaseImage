#!/usr/bin/env bash

# This script will check for 3 variables to update the proxy settings:
#
# DOCKER_CONTAINER_PROXY_PROTOCOL
# DOCKER_CONTAINER_PROXY_HOST
# DOCKER_CONTAINER_PROXY_PORT
#
# Most likely these varibales will be set as "build-args" during creation of the image
# If they all exist the script can perform several updates on configuration files for applications that nee a proxy.

if [ -z "${DOCKER_CONTAINER_PROXY_PROTOCOL}" ] && [ -z "${DOCKER_CONTAINER_PROXY_HOST}" ] && [ -z "${DOCKER_CONTAINER_PROXY_PORT}" ];
then
    echo "Skipping proxy configuration for container...";
else
    echo "Setting up proxy configurations for container...";

    # 1. Setting environment variables
    echo "Setting up proxy environment variables...";
    export http_proxy="${DOCKER_CONTAINER_PROXY_PROTOCOL}://${DOCKER_CONTAINER_PROXY_HOST}:${DOCKER_CONTAINER_PROXY_PORT}"
    export https_proxy="${DOCKER_CONTAINER_PROXY_PROTOCOL}://${DOCKER_CONTAINER_PROXY_HOST}:${DOCKER_CONTAINER_PROXY_PORT}"
    export HTTP_PROXY="${DOCKER_CONTAINER_PROXY_PROTOCOL}://${DOCKER_CONTAINER_PROXY_HOST}:${DOCKER_CONTAINER_PROXY_PORT}"
    export HTTPS_PROXY="${DOCKER_CONTAINER_PROXY_PROTOCOL}://${DOCKER_CONTAINER_PROXY_HOST}:${DOCKER_CONTAINER_PROXY_PORT}"

    # 2. Setting proxy for apt
    echo "Setting up proxy for apt ...";
    envsubst "$DOCKER_CONTAINER_PROXY_PROTOCOL:$DOCKER_CONTAINER_PROXY_HOST:$DOCKER_CONTAINER_PROXY_PORT" < /opt/config/apt_template.conf > /etc/apt/apt.conf

    # 3. Setting proxy for curl
    echo "Setting up proxy for curl ...";
    envsubst "$DOCKER_CONTAINER_PROXY_PROTOCOL:$DOCKER_CONTAINER_PROXY_HOST:$DOCKER_CONTAINER_PROXY_PORT" < /opt/config/.curlrc_template > ~/.curlrc
fi