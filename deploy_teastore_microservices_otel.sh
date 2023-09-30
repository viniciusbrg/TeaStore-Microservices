#!/bin/bash

APP_CLUSTER=$(aws eks update-kubeconfig --name app-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
LOADTEST_CLUSTER=$(aws eks update-kubeconfig --name loadtester-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
BACKEND_CLUSTER=$(aws eks update-kubeconfig --name backend-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')

kubectl config use-context $BACKEND_CLUSTER
kubectl apply -f microservices/examples/kubernetes/otel-manifests/backend/

OTEL_BACKEND_IP=$(kubectl describe nodes | grep -m1 ExternalIP | cut -d ":" -f2)

echo "====== IP to Access Backend ======"

kubectl describe nodes | grep ExternalIP

echo "==================================="

kubectl config use-context $APP_CLUSTER

# backup
cp microservices/examples/kubernetes/otel-manifests/otel-collector-config.yaml otel-collector-config-old.yaml

bash update_collector_placeholders.sh $OTEL_BACKEND_IP > otel-collector-config.yaml
mv otel-collector-config.yaml microservices/examples/kubernetes/otel-manifests/
kubectl apply -f microservices/examples/kubernetes/otel-manifests/
kubectl apply -f microservices/examples/kubernetes/teastore-ribbon-otel.yaml

# undo file changes
mv ./otel-collector-config-old.yaml microservices/examples/kubernetes/otel-manifests/otel-collector-config.yaml

echo "====== IP to Access TeaStore ======"

kubectl describe nodes | grep ExternalIP

echo "==================================="

kubectl config use-context $LOADTEST_CLUSTER

kubectl apply -f microservices/examples/locust-kubernetes/scripts-cm.yaml
kubectl apply -f microservices/examples/locust-kubernetes/master-deployment.yaml
kubectl apply -f microservices/examples/locust-kubernetes/service.yaml
kubectl apply -f microservices/examples/locust-kubernetes/nodeport.yaml
kubectl apply -f microservices/examples/locust-kubernetes/slave-deployment.yaml


echo "====== IP to Access Locust ======"

kubectl describe nodes | grep ExternalIP

echo "==================================="
