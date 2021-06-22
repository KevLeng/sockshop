# Dynatrace Sockshop Demo Application

Demo application for use on Kubernetes. This has been test on: GKE, AKS, EKS, MicroK8S & K3s.

Also includes [monitoring-as-code](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code) (aka Monaco) configuration to push the required configuration into your environment.

## Deployment / Installation

Clone this repo, then to deploy sockshop run:

`./deploy-sockshop`

To deploy (install) monaco, run:

`./deploy-monaco.ah`

*Optional*: If you are running MicroK8S or K3s (this is **NOT** required for GKE, AKS, EKS) run:

Please note for MicroK8S the NGINX addon is required: `microk8s enable ingress`

`./deploy-ingress.sh`


## Push Configuration
To push monaco config first export the required environment vaiables ([DT_TENANT](#DT_TENANT), [DT_API_TOKEN](#DT_API_TOKEN), [DT_DASHBOARD_OWNER](#DT_DASHBOARD_OWNER)), then run the script:

```bash
export DT_TENANT=<Your Dynatrace Tenant URL>
export DT_API_TOKEN=<Your Dynatrace Token>
export DT_DASHBOARD_OWNER=<Your Dynatrace User Email Address>

./push-monaco.sh
```

### Environment Variables

The following are required variables.

#### DT_TENANT

DT_TENANT is the URL of your Dynatrace tenant, defaults to `none`

For Dynatrace SaaS:
```bash
export DT_TENANT="https://<tenantId>.live.dynatrace.com"`
```
For Dynatrace Managed:
```bash
export DT_TENANT="https://<clusterId>.dynatrace-managed.com/e/<environmentId>"
```
#### DT_API_TOKEN

DT_API_TOKEN is the Dynatrace API token used to push the configuration to your tenant, defaults to `none`. It required the following permissions:
```json
{
  "name": "MONACO",
  "scopes": [
    "DataExport",
    "ExternalSyntheticIntegration",
    "LogExport",
    "ReadConfig",
    "WriteConfig",
    "ReadSyntheticData",
    "slo.read",
    "slo.write"
  ]
}
```
```bash
export DT_TENANT="dt0c01.<Public portion of token>.<Secret portion of token>"
```
#### DT_DASHBOARD_OWNER

DT_DASHBOARD_OWNER is the email address of the user that will be assigned the "owner" of the created dashboards, defaults to `kevin.leng@dynatrace.com`.
```bash
export DT_DASHBOARD_OWNER="kevin.leng@dynatrace.com"
```


## Monitoring as code

The following will be created in your environment:

* Web Applications (2) with the associated application detection rules
* Synthetic tests (1 HTTP Check, 1 Browser Monitor, 1 Multi Step Transaction)
* Service Naming Rules
* Process Naming Rules
* Management Zones
* Service Level Objectives
* Dashboards

Optionally:
Azure Integration