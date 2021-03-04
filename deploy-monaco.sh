
#!/bin/bash
# This script will install Monitoring as Code

monaco_version="v1.4.0"
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


echo "Download Monaco & make executable"
curl -L https://github.com/dynatrace-oss/dynatrace-monitoring-as-code/releases/download/{$monaco_version}/monaco-linux-amd64 --output monaco_cli

chmod +x monaco_cli