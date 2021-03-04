#!/bin/bash
# This script will push the  Monitoring as Code config

export dev_frontend_ip=$(kubectl describe svc front-end -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
export dev_carts_ip=$(kubectl describe svc carts -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')

export production_frontend_ip=$(kubectl describe svc front-end -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
export production_carts_ip=$(kubectl describe svc carts -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')

echo "Calling Monaco with sockshop config..."
./monaco_cli -e=monaco/sockshop-environment.yaml -p=sockshop monaco

echo "Finished."