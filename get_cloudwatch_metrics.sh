#!/bin/bash

APP_CLUSTER=$(aws eks update-kubeconfig --name app-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
LOADTEST_CLUSTER=$(aws eks update-kubeconfig --name loadtester-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')
BACKEND_CLUSTER=$(aws eks update-kubeconfig --name backend-cluster | sed -e 's/Added new context //g' -e 's/ to .*//g' -e 's/Updated context //g' -e 's/ in .*//g')

kubectl config use-context $APP_CLUSTER

kubectl get nodes -o wide | awk -v OFS='\t\t' '{print $6}' | tail -n +2 | xargs -l bash -c './save_metrics.sh app $0'

kubectl config use-context $BACKEND_CLUSTER

kubectl get nodes -o wide | awk -v OFS='\t\t' '{print $6}' | tail -n +2 | xargs -l bash -c './save_metrics.sh backend $0'

kubectl config use-context $LOADTEST_CLUSTER

kubectl get nodes -o wide | awk -v OFS='\t\t' '{print $6}' | tail -n +2 | xargs -l bash -c './save_metrics.sh load $0'
