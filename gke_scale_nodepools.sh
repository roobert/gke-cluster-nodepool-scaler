#!/usr/bin/env bash

NODE_COUNT="${1}"
PROJECTS="${2}"
TOPIC="gke-cluster-nodepool-scaler"

set -euo pipefail

if [[ $# != 2 ]]; then
  echo "usage: $0 <node count> \"<project> ...\""
  exit 1
fi

for project in ${PROJECTS}; do
  gcloud --project "${project}" pubsub topics publish "${TOPIC}" --message "{\"nodes\":${NODE_COUNT}}"
done
