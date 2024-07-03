#!/bin/bash

set -euo pipefail

echo 
echo "***   Installing KinD Kubernetes Cluster  ***"
kind create cluster 

echo 
echo "***   Exporting Kubernetes Config  ***"
kind export kubeconfig  --internal

echo 
echo "***   Installing Calico Network Plugin  ***"
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo 
echo "***   Mounting client app image into KinD cluster  ***"
kind load docker-image python-app

echo 
echo "***   Installing Strimzi Helm Charts  ***"
kubectl create namespace kafka 
helm repo add strimzi https://strimzi.io/charts/
helm repo update
helm install strimzi strimzi/strimzi-kafka-operator --namespace kafka

echo
echo "***   Installing Kubernetes Dashboard UI  ***"
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

echo
echo "***   Waiting for Strimzi Cluster Operator to be ready  ***"
kubectl wait --for=condition=ready pod -n kafka -l name=strimzi-cluster-operator --timeout=240s

echo
echo "***   Done!  ***"