#!/usr/bin/env bash
#
# (c) Copyright 2022 by Swiss Post, Information Technology Services
#
#

set -o errexit

archive_name="build.tar.gz"

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "Usage: e2e.sh"
      echo "Starts the end-to-end environment of e-voting."
      echo "E-voting services will start as docker containers and the multiple Secure Data Manager instances will be configured for an end-to-end test."
      echo "The script expects an existing archive ${archive_name} next to it in the same folder. This archive is generated by the build.sh script of e-voting."
      echo
      echo "WARNING: This script only works if docker and docker-compose is installed on the machine running it."
      exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

echo "Extracting ${archive_name} archive. Please wait..."
tar -xf ${archive_name}

current_dir=$(pwd)

export EVOTING_DOCKER_HOME=$current_dir/evoting-e2e-dev
export DOCKER_REGISTRY=registry.gitlab.com/swisspost-evoting/e-voting/evoting-e2e-dev
export EVOTING_HOME=$current_dir/e-voting

echo "Creating and running docker containers for an end-to-end test. Please wait..."
cd evoting-e2e-dev
./scripts/prepare-e2e.sh
cd ..

echo "Configuring the multiple Secure Data Manager instances. Please wait..."
./evoting-e2e-dev/scripts/prepare-multiple-sdm.sh

echo "End-to-end environment of e-voting ready!"
