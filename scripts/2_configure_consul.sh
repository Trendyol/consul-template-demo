#!/bin/sh

# run this script in consul server container
# kubectl exec -ti -n hashicorp consul-consul-server-0 sh

# write required kv pairs
consul kv put apps/example/serverPort "8080"
consul kv put apps/example/fooEnabled true
consul kv put apps/example/dbUsername "db-username"
