#!/bin/sh

# run this script in vault container
# kubectl exec -ti -n hashicorp vault-0 sh

# init, unseal, login as root, create
mkdir /vault/tmp &&
vault operator init -key-shares=1 -key-threshold=1 > /vault/tmp/vault-init.txt &&
cat /vault/tmp/vault-init.txt | grep "Unseal Key" | cut -d' ' -f4 > /vault/tmp/vault-unseal-key.txt &&
cat /vault/tmp/vault-init.txt | grep "Initial Root Token" | cut -d' ' -f4 > /vault/tmp/vault-root-token.txt &&
vault operator unseal "$(cat /vault/tmp/vault-unseal-key.txt)" &&
vault login "$(cat /vault/tmp/vault-root-token.txt)"

# enable kv-v2 secrets engine at path "secret"
vault secrets enable -version=2 -path="secret" kv

# write a secret to secret/apps/example path
vault kv put secret/apps/example dbPassword=my-secret-password

# enable the Kubernetes authentication method
vault auth enable --path="my-kube" kubernetes

# configure the Kubernetes authentication method
vault write auth/my-kube/config \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# create a policy named example-policy that enables the read capability for secret at path secret/apps/example
vault policy write example-policy - <<EOH
path "secret/data/apps/example" {
  capabilities = ["read"]
}
EOH

# create a Kubernetes authentication role named example-role to bind service account in K8s to policy in Vault
vault write auth/my-kube/role/example \
        bound_service_account_names=example-sa \
        bound_service_account_namespaces=test \
        policies=example-policy \
        ttl=24h

# create a token with example policy
vault token create --policy example-policy

# export VAULT_TOKEN=<paste_token_here>