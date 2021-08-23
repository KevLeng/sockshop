#!/bin/bash
# Dynatrace Variables
export DT_TENANT=${DT_TENANT:-none}
export DT_API_TOKEN=${DT_API_TOKEN:-none}


if [[ "$DT_TENANT" == "none" ]]; then
    echo "You have to set DT_TENANT to your Tenant URL, e.g: abc12345.dynatrace.live.com or yourdynatracemanaged.com/e/abcde-123123-asdfa-1231231"
    exit 1
fi
if [[ "$DT_API_TOKEN" == "none" ]]; then
    echo "You have to set DT_API_TOKEN to a Token that has 'read configuration', 'write configuration'"
    exit 1
fi

echo "Pushing metric event..."
RESPONSE=$(curl -X POST "$DT_TENANT/api/config/v1/anomalyDetection/metricEvents" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_API_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @./config/oomkill-custom-event.json)

echo -e "$RESPONSE"

sleep 10

echo "Applying new build..."
kubectl apply -f manifests/sockshop-app/newbuilds/newbuild-quota.yml
echo "Completed."