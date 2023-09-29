#!/bin/bash

BACKEND_IP=$1

cat ./microservices/examples/kubernetes/otel-manifests/otel-collector-config.yaml | \
sed 's#\${BACKEND_URL_PLACEHOLDER}'"#${BACKEND_IP}#g"