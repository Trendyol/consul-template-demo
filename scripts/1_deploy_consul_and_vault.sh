#!/bin/sh

kubectl create ns hashicorp
kubectl create ns test

helm install -f deploy/helm/consul-helm/consul-custom-values.yml -n hashicorp consul deploy/helm/consul-helm
helm install -f deploy/helm/vault-helm/vault-custom-values.yml -n hashicorp vault deploy/helm/vault-helm
