#!/bin/bash

APP_CLUSTER=$(aws eks update-kubeconfig --name app-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
LOADTEST_CLUSTER=$(aws eks update-kubeconfig --name loadtester-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
BACKEND_CLUSTER=$(aws eks update-kubeconfig --name backend-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')

kubectl config use-context $BACKEND_CLUSTER
kubectl delete -f microservices/examples/kubernetes/otel-manifests/backend/

kubectl config use-context $APP_CLUSTER
kubectl delete -f microservices/examples/kubernetes/otel-manifests/
kubectl delete -f microservices/examples/kubernetes/teastore-ribbon-otel.yaml

kubectl config use-context $LOADTEST_CLUSTER
kubectl delete -f microservices/examples/locust-kubernetes/

echo "==================================="
