#!/bin/bash

APP_CLUSTER=$(aws eks update-kubeconfig --name app-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
LOADTEST_CLUSTER=$(aws eks update-kubeconfig --name loadtester-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')

kubectl config use-context $APP_CLUSTER

kubectl apply -f microservices/examples/kubernetes/otel-manifests/
kubectl apply -f monolith/examples/kubernetes/db.yml
sleep 15
kubectl apply -f monolith/examples/kubernetes/k8s-otel.yml

sleep 20
# only scale once app is running
kubectl scale deployment teastore-app --replicas=4

echo "====== IP to Access TeaStore ======"

kubectl describe nodes | grep ExternalIP

echo "==================================="

kubectl config use-context $LOADTEST_CLUSTER

kubectl apply -f microservices/examples/locust-kubernetes/

echo "====== IP to Access Locust ======"

kubectl describe nodes | grep ExternalIP

echo "==================================="
