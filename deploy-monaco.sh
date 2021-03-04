
#!/bin/bash
# This script will install Monitoring as Code

monaco_version="v1.4.0"


echo "Download Monaco"
curl -L https://github.com/dynatrace-oss/dynatrace-monitoring-as-code/releases/download/{$monaco_version}/monaco-linux-amd64 --output monaco_cli
echo "Make executable"
chmod +x monaco_cli