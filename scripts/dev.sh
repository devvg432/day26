#!/bin/bash

RESOURCE_GROUP_NAME=terraform-state-rg
STAGE_SA_ACCOUNT=tfstagebackend2024dev
DEV_SA_ACCOUNT=tfdevbackend2024dev
CONTAINER_NAME=tfstate
LOCATION=canadacentral

# Login to Azure (if not already logged in)
az account show > /dev/null 2>&1 || az login

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account for staging environment
az storage account create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $STAGE_SA_ACCOUNT \
  --sku Standard_LRS \
  --encryption-services blob \
  --location $LOCATION

# Create storage account for dev environment
az storage account create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $DEV_SA_ACCOUNT \
  --sku Standard_LRS \
  --encryption-services blob \
  --location $LOCATION

# Create blob container for staging environment
az storage container create --name $CONTAINER_NAME --account-name $STAGE_SA_ACCOUNT --auth-mode login

# Create blob container for dev environment
az storage container create --name $CONTAINER_NAME --account-name $DEV_SA_ACCOUNT --auth-mode login
