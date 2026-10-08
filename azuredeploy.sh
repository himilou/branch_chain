#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="barkandchain"
LOCATION="westus3"
ENVIRONMENT_NAME="barkandchain-env"
APP_NAME="barkandchain-web-app"

cd "$(dirname "$0")"

#az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Create the environment (and its Log Analytics workspace) only once.
ENVIRONMENT_COUNT="$(az containerapp env list \
  --resource-group "$RESOURCE_GROUP" \
  --query "[?name=='$ENVIRONMENT_NAME'] | length(@)" \
  --output tsv)"

if [[ "$ENVIRONMENT_COUNT" == "0" ]]; then
  az containerapp env create \
    --name "$ENVIRONMENT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION"
fi

# Build the project from its Dockerfile and deploy it
az containerapp up \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --environment "$ENVIRONMENT_NAME" \
  --source . \
  --target-port 80 \
  --ingress external 
#  --output none

# Configure resources and scaling after the app has been created
az containerapp update \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --cpu 0.25 \
  --memory 0.5Gi \
  --min-replicas 0 \
  --max-replicas 1

az containerapp show \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query properties.configuration.ingress.fqdn \
  --output tsv
