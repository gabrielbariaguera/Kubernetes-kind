#!/bin/bash

kubectl apply -f https://github.com/prometheus-operator/kube-prometheus/releases/download/v0.12.0/kube-prometheus-manifests/setup/
sleep 10
kubectl apply -f https://github.com/prometheus-operator/kube-prometheus/releases/download/v0.12.0/kube-prometheus-manifests/