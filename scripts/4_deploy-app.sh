#!/bin/sh

envsubst < deploy/application.yml | kubectl apply -f -