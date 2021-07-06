#!/bin/bash
# Required for environments like k3s, not required to AKS, GKE etc
# expects to be running on ubuntu EC2 instance


PUBLIC_IP=$(curl -s ifconfig.me)
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
NIP_DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

export DOMAIN=${DOMAIN:-$NIP_DOMAIN}
export INGRESSCLASS=${INGRESSCLASS:-"istio"}
echo "Deploying $INGRESSCLASS ingress for sockshop"
echo "Using Domain: $DOMAIN"

createINGFile(){
  echo "Create Environment=$ENV, SERVICE=$SERVICE, PORT=$PORT ingress."

cat > ./sockshop-ingress.yaml <<- EOM
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: $INGRESSCLASS
  name: $SERVICE
  namespace: $ENV
spec:
  rules:
  - host: $ENV.$SERVICE.$DOMAIN
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: $SERVICE
            port:
              number: $PORT
EOM

  kubectl apply -f sockshop-ingress.yaml
}

#front-end
export ENV=production
export SERVICE=front-end
export PORT=8080
createINGFile

export ENV=dev
export SERVICE=front-end
export PORT=8080
createINGFile


#carts
export ENV=production
export SERVICE=carts
export PORT=80
createINGFile

export ENV=dev
export SERVICE=carts
export PORT=80
createINGFile


rm sockshop-ingress.yaml

echo "Production frontend: http://production.front-end.$DOMAIN"
echo "Dev frontend: http://dev.front-end.$DOMAIN"
echo "Production carts: http://production.carts.$DOMAIN"
echo "Dev carts: http://dev.carts.$DOMAIN"
