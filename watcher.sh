#!/bin/bash

#Define variables
NAMESPACE="sre"
DEPLOYMENT="swype-app"
MAX_RESTARTS=4

while true; do
  # Retrieve the restart count of the specified deployment pod
  RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

  echo "Pod ${DEPLOYMENT} has restarted ${RESTARTS} times."

  # Compare restart count against the threshold
  if (( RESTARTS > MAX_RESTARTS )); then
    echo "Alert: Pod ${DEPLOYMENT} has exceeded the permissible restart limit. Initiating scale down."
    kubectl scale --replicas=0 deployment/${DEPLOYMENT} -n ${NAMESPACE}
    break
  fi

  # Delay the next execution to minimize resource usage
  echo "Waiting for 60 seconds before the next status check..."
  sleep 60
done
