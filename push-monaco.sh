#!/bin/bash
# This script will push the  Monitoring as Code config

DT_TENANT=${DT_TENANT:-none}
DT_API_TOKEN=${DT_API_TOKEN:-none}


if [[ "$DT_TENANT" == "none" ]]; then
    echo "You have to set DT_TENANT to your Tenant URL, e.g: abc12345.dynatrace.live.com or yourdynatracemanaged.com/e/abcde-123123-asdfa-1231231"
    exit 1
fi
if [[ "$DT_API_TOKEN" == "none" ]]; then
    echo "You have to set DT_API_TOKEN to a Token that has read/write configuration, access metrics, log content and capture request data priviliges"
    exit 1
fi


export dev_frontend_ip=$(kubectl describe svc front-end -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
export dev_carts_ip=$(kubectl describe svc carts -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')

export production_frontend_ip=$(kubectl describe svc front-end -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
export production_carts_ip=$(kubectl describe svc carts -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')

echo "Calling Monaco with sockshop config..."
./monaco_cli -e=monaco/sockshop-environment.yaml -p=sockshop monaco

echo "Finished."