#!/bin/bash

APP_CLUSTER=$(aws eks update-kubeconfig --name app-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
BACKEND_CLUSTER=$(aws eks update-kubeconfig --name backend-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')

kubectl config use-context $APP_CLUSTER
COLLECTOR_IP=$(kubectl describe nodes | grep -m1 ExternalIP | cut -d ":" -f2 | sed -e 's/^[ \t]*//')

kubectl config use-context $BACKEND_CLUSTER
BACKEND_IP=$(kubectl describe nodes | grep -m1 ExternalIP | cut -d ":" -f2 | sed -e 's/^[ \t]*//')

cat ./otel-collector-config-example.yaml | \
sed 's#\${BACKEND_URL_PLACEHOLDER}'"#${BACKEND_IP}#g" > ./microservices/examples/kubernetes/otel-manifests/otel-collector-config.yaml

cat ./prometheus-config-example.yml | \
sed 's#\${PROM_COLLECTOR_URL_PLACEHOLDER}'"#${COLLECTOR_IP}#g" > ./microservices/examples/kubernetes/otel-manifests/backend/prometheus-config.yml 
