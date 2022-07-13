#!/usr/bin/env bash
#
# (c) Copyright 2022 by Swiss Post, Information Technology Services
#
#

set -o errexit

archive_name="build.tar.gz"
e_voting="e-voting"
evoting_e2e_dev="evoting-e2e-dev"

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "Usage: e2e.sh"
      echo "Starts the end-to-end environment of e-voting."
      echo "E-voting services will start as docker containers and the multiple Secure Data Manager instances will be configured for an end-to-end test."
      echo
      echo "The script expects one of the following folder hierarchies to be true:"
      echo "1. <any directory>"
      echo "   |- ${e_voting}/ (built)"
      echo "   |- ${evoting_e2e_dev}/"
      echo "   |- e2e.sh"
      echo
      echo "2. <any directory>"
      echo "   |- ${archive_name} (containing the ${e_voting} [built] and ${evoting_e2e_dev}. This is generated by the evoting-build docker image)"
      echo "   |- e2e.sh"
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

if [[ ! -d "${e_voting}" ]] || [[ ! -d "${evoting_e2e_dev}" ]]; then
  if [ ! -f "${archive_name}" ]; then
    echo "Missing ${archive_name}!"
    exit 1
  fi
  echo "Opening ${archive_name} archive. Please wait..."
  tar -xf ${archive_name}
  echo "Archive successfully opened."
else
  echo "Folders ${e_voting} and ${evoting_e2e_dev} are already present."
fi

current_dir=$(pwd)

export EVOTING_DOCKER_HOME=$current_dir/evoting-e2e-dev
export DOCKER_REGISTRY=registry.gitlab.com/swisspost-evoting/e-voting/evoting-e2e-dev
export EVOTING_HOME=$current_dir/e-voting

echo "Creating and running docker containers for an end-to-end test. Please wait..."
cd evoting-e2e-dev
./scripts/prepare-e2e.sh
cd ..

echo "End-to-end environment of e-voting ready!"
