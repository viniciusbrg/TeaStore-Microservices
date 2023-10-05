#!/bin/bash

APP_CLUSTER=$(aws eks update-kubeconfig --name app-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
LOADTEST_CLUSTER=$(aws eks update-kubeconfig --name loadtester-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
BACKEND_CLUSTER=$(aws eks update-kubeconfig --name backend-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')

kubectl config use-context $BACKEND_CLUSTER
kubectl apply -f microservices/examples/kubernetes/otel-manifests/backend/

echo "====== IP to Access Backend ======"

kubectl describe nodes | grep ExternalIP

echo "==================================="

kubectl config use-context $APP_CLUSTER

kubectl apply -f microservices/examples/kubernetes/otel-manifests/
kubectl apply -f monolith/examples/kubernetes/db.yml
sleep 15
kubectl apply -f monolith/examples/kubernetes/k8s-otel.yml

echo "====== IP to Access TeaStore ======"

kubectl describe nodes | grep ExternalIP

echo "==================================="

kubectl config use-context $LOADTEST_CLUSTER

kubectl apply -f microservices/examples/locust-kubernetes/

echo "====== IP to Access Locust ======"

kubectl describe nodes | grep ExternalIP

echo "==================================="
