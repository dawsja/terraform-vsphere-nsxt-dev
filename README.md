# vsphere-nsxt-terraform

Terraform project for managing vSphere and NSX-T infrastructure using a remote AzureRM backend.

## Providers

| Provider | Version |
|----------|---------|
| hashicorp/vsphere | ~> 2.16.0 |
| vmware/nsxt | ~> 3.11.1 |

## Backend

State is stored remotely in Azure Blob Storage via the `azurerm` backend.

## Prerequisites

- Terraform >= 1.15.3
- Access to a vCenter Server and NSX-T Manager
- Azure storage account for remote state

## Usage

**1. Set environment variables**

```bash
# vSphere credentials
export TF_VAR_vsphere_user=""
export TF_VAR_vsphere_password=""

# NSX-T credentials
export TF_VAR_nsxt_username=""
export TF_VAR_nsxt_password=""

# Azure backend authentication
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_TENANT_ID=""
export ARM_SUBSCRIPTION_ID=""
```

**2. Copy and review the example variables file**

```bash
cp terraform.tfvars.example terraform.auto.tfvars
```

Edit `terraform.auto.tfvars` with your non-sensitive values (hostnames, SSL settings).

**3. Initialize and apply**

```bash
terraform init
terraform plan
terraform apply
```

All configurations and values have been sanitized for public demonstration purposes.
