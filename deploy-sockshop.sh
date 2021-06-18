#!/bin/bash

export DEPLOY_LOADGEN=${DEPLOY_LOADGEN:-true}

kubectl create -f manifests/k8s-namespaces.yml

kubectl apply -f manifests/backend-services/user-db/dev/
kubectl apply -f manifests/backend-services/user-db/production/

kubectl apply -f manifests/backend-services/shipping-rabbitmq/dev/
kubectl apply -f manifests/backend-services/shipping-rabbitmq/production/

kubectl apply -f manifests/backend-services/carts-db/

kubectl apply -f manifests/backend-services/catalogue-db/

kubectl apply -f manifests/backend-services/orders-db/

kubectl apply -f manifests/sockshop-app/dev/
kubectl apply -f manifests/sockshop-app/production/

kubectl -n dev create rolebinding default-view --clusterrole=view --serviceaccount=dev:default
kubectl -n production create rolebinding default-view --clusterrole=view --serviceaccount=production:default

if [[ "$DEPLOY_LOADGEN" == "true" ]]; then
    ./deploy-loadgen.sh
fi