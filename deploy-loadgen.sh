#!/bin/bash

echo "Deploying Loadgen"
echo "Waiting for production front-end pod to be inready state..."
kubectl wait po -n production -l app.kubernetes.io/name=front-end --for=condition=ready --timeout=120s

echo "Applying manifests..."
kubectl apply -f manifests/loadgen/
