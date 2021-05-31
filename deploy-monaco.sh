#!/bin/bash
# This script will install Monitoring as Code

monaco_version="v1.5.3"


echo "Download Monaco & make executable"
curl -L https://github.com/dynatrace-oss/dynatrace-monitoring-as-code/releases/download/{$monaco_version}/monaco-linux-amd64 --output monaco_cli

chmod +x monaco_cli