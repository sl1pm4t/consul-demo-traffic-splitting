#!/bin/bash
set -e

ENVOY_LOG_LEVEL="${ENVOY_LOG_LEVEL:-info}"

# Wait for Consul to be responding
until curl -s http://127.0.0.1:8500/v1/connect/ca/roots
do
  echo "Could not contact consul, trying again in 5s..."
  sleep 5;
done

export CONSUL_DC="${CONSUL_DC:-dc1}"
trust_domain=$(curl -s http://127.0.0.1:8500/v1/connect/ca/roots | jq -r '.TrustDomain' )
while [ -z "$trust_domain" ]
do
  echo "Could not identify consul trust domain, trying again in 5s..."
  sleep 5;
  trust_domain=$(curl -s http://127.0.0.1:8500/v1/connect/ca/roots | jq -r '.TrustDomain' )
done

echo "Consul Trust Domain: ${trust_domain}"
export CONSUL_TRUST_DOMAIN="${trust_domain}"

echo "Generating envoy.yaml config file with values: CONSUL_DC=${CONSUL_DC} | CONSUL_TRUST_DOMAIN=${CONSUL_TRUST_DOMAIN} ..."
cat /config/edge-envoy.yaml | envsubst \$CONSUL_DC,\$CONSUL_TRUST_DOMAIN > /envoy.yaml

echo "Starting Envoy..."
/usr/local/bin/envoy -c /envoy.yaml -l ${ENVOY_LOG_LEVEL}