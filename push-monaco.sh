#!/bin/bash
# This script will push the  Monitoring as Code config

# Dynatrace Variables
export DT_TENANT=${DT_TENANT:-none}
export DT_API_TOKEN=${DT_API_TOKEN:-none}
export DT_DEFAULT_GEOS=${DT_DEFAULT_GEOS:-true}
export DT_DASHBOARD_OWNER=${DT_DASHBOARD_OWNER:-"kevin.leng@dynatrace.com"}

# AZURE Variables
export SKIP_AZURE=${SKIP_AZURE:-true}
export AZURE_CLIENT_ID=${AZURE_CLIENT_ID:-none}
export AZURE_TENANT_ID=${AZURE_TENANT_ID:-none}
export AZURE_KEY=${AZURE_KEY:-none}

# Prometheus Variables
export SKIP_PROMETHEUS=${SKIP_PROMETHEUS:-false}



if [[ "$DT_TENANT" == "none" ]]; then
    echo "You have to set DT_TENANT to your Tenant URL, e.g: abc12345.dynatrace.live.com or yourdynatracemanaged.com/e/abcde-123123-asdfa-1231231"
    exit 1
fi
if [[ "$DT_API_TOKEN" == "none" ]]; then
    echo "You have to set DT_API_TOKEN to a Token that has 'read configuration', 'write configuration', 'Create and read synthetic monitors, locations, and nodes', 'Access problem and event feed, metrics, and topology'"
    exit 1
fi
if [[ "$SKIP_AZURE" == "false" ]]; then
    if [[ "$AZURE_CLIENT_ID" == "none" ]]; then
        echo "You have to set AZURE_CLIENT_ID to the Application (client) ID for the Azure service principal. See help for more details: https://www.dynatrace.com/support/help/technology-support/cloud-platforms/microsoft-azure-services/set-up-integration-with-azure-monitor/"
        exit 1
    fi
    if [[ "$AZURE_TENANT_ID" == "none" ]]; then
        echo "You have to set AZURE_TENANT_ID to the Directory (tenant) ID for the Azure service principal. See help for more details: https://www.dynatrace.com/support/help/technology-support/cloud-platforms/microsoft-azure-services/set-up-integration-with-azure-monitor/"
        exit 1
    fi
    if [[ "$AZURE_KEY" == "none" ]]; then
        echo "You have to set AZURE_KEY to the client secret value for the Azure service principal. See help for more details: https://www.dynatrace.com/support/help/technology-support/cloud-platforms/microsoft-azure-services/set-up-integration-with-azure-monitor/"
        exit 1
    fi
fi

export synth_geo_location_id_1=${synth_geo_location_id_1:-"GEOLOCATION-8888B6EC387C46E6"}
export synth_geo_location_id_2=${synth_geo_location_id_2:-"GEOLOCATION-C196364332B5D8E2"}

if [[ "$DT_TENANT" == *"sprint"* ]]; then
    if [[ "$DT_DEFAULT_GEOS" == "true" ]]; then
        echo "Sprint environment, using sprint geo location ids"
        export synth_geo_location_id_1="GEOLOCATION-0DF9A0E1095A5A62" #Portland
        export synth_geo_location_id_2="GEOLOCATION-E01B833216FC3598" #Hong Kong
    fi
fi

echo "Gathering environment details..."
echo ""
export dev_frontend_ip=$(kubectl describe svc front-end -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
export dev_carts_ip=$(kubectl describe svc carts -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')

export production_frontend_ip=$(kubectl describe svc front-end -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
export production_carts_ip=$(kubectl describe svc carts -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')

export production_frontend_port="8080"
export production_carts_port="80"

if [[ $dev_frontend_ip == "" ]]; then
  echo "dev_frontend_ip is not found trying host from ingress"
  export dev_frontend_ip=$(kubectl get ing front-end -n dev -o jsonpath='{.spec.rules[0].host}')
fi

if [[ $dev_carts_ip == "" ]]; then
  echo "dev_carts_ip is not found trying host from ingress"
  export dev_carts_ip=$(kubectl get ing carts -n dev -o jsonpath='{.spec.rules[0].host}')
fi

if [[ $production_frontend_ip == "" ]]; then
  echo "production_frontend_ip is not found trying host from ingress"
  export production_frontend_ip=$(kubectl get ing front-end -n production -o jsonpath='{.spec.rules[0].host}')
  export production_frontend_port="80"
fi

if [[ $production_carts_ip == "" ]]; then
  echo "production_carts_ip is not found trying host from ingress"
  export production_carts_ip=$(kubectl get ing carts -n production -o jsonpath='{.spec.rules[0].host}')
fi

echo "**************************************************"
echo "Using the following:"
echo "dev front-end: $dev_frontend_ip"
echo "dev carts: $dev_carts_ip"
echo "production front-end: $production_frontend_ip"
echo "production carts: $production_carts_ip"
echo "**************************************************"
echo ""
echo "Calling Monaco with sockshop config..."
./monaco_cli -e=monaco/sockshop-environment.yaml -p=sockshop monaco

echo "Finished."