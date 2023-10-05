#!/bin/bash

APP_CLUSTER=$(aws eks update-kubeconfig --name app-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
LOADTEST_CLUSTER=$(aws eks update-kubeconfig --name loadtester-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')

kubectl config use-context $APP_CLUSTER

kubectl delete -f microservices/examples/kubernetes/otel-manifests/
kubectl delete -f monolith/examples/kubernetes/db.yml
kubectl delete -f monolith/examples/kubernetes/k8s-otel.yml

kubectl config use-context $LOADTEST_CLUSTER

kubectl delete -f microservices/examples/locust-kubernetes/

echo "==================================="
