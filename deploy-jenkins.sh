#!/bin/bash
# This script will deploy jenkins for Monitoring as Code in a pipleine
# assumes helm 3 is installed already

PUBLIC_IP=$(curl -s ifconfig.me)
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
NIP_DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

export DOMAIN=${DOMAIN:-$NIP_DOMAIN}
export INGRESSCLASS=${INGRESSCLASS:-"istio"}

echo "Create jenkins namespace"
kubectl create ns jenkins
echo "Deploy jenkins using helm"
helm repo add jenkins https://charts.jenkins.io

helm repo update

helm install jenkins jenkins/jenkins --set controller.jenkinsUrl=http://jenkins.$DOMAIN -f jenkins/values.yaml
echo "Waiting for jenkins to start"
kubectl wait po -n jenkins -l app.kubernetes.io/name=jenkins --for=condition=ready --timeout=120s

echo "Deploy ingress"
cat > ./sockshop-ingress.yaml <<- EOM
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: $INGRESSCLASS
  name: jenkins
  namespace: jenkins
spec:
  rules:
  - host: jenkins.$DOMAIN
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: jenkins
            port:
              number: 8080
EOM

kubectl apply -f sockshop-ingress.yaml
rm sockshop-ingress.yaml


echo "Jenkins Password is"

kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo

