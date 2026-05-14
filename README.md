# vsphere-nsxt-terraform

Terraform project for managing vSphere and NSX-T infrastructure using a remote AzureRM backend.

## Providers

| Provider | Version |
|----------|---------|
| vmware/vsphere | ~> 2.16.0 |
| vmware/nsxt | ~> 3.11.1 |

## Variables

| Name | Type | Default | Sensitive | Description |
|---|---|---|---|---|
| `vsphere_user` | `string` | required | yes | Username for authenticating to the vSphere API |
| `vsphere_password` | `string` | required | yes | Password for authenticating to the vSphere API |
| `vsphere_server` | `string` | required | no | Hostname or IP address of the vCenter Server |
| `vsphere_allow_unverified_ssl` | `bool` | `false` | no | Allow unverified SSL certificates for vSphere. Set to `false` in production |
| `nsxt_host` | `string` | required | no | Hostname or IP address of the NSX-T Manager |
| `nsxt_username` | `string` | required | no | Username for authenticating to the NSX-T API |
| `nsxt_password` | `string` | required | yes | Password for authenticating to the NSX-T API |
| `nsxt_allow_unverified_ssl` | `bool` | `false` | no | Allow unverified SSL certificates for NSX-T. Set to `false` in production |
| `vsphere_datacenter` | `string` | required | no | Name of the vSphere datacenter |
| `vsphere_cluster` | `string` | required | no | Name of the vSphere compute cluster |
| `vms` | `map(object)` | `{}` | no | Map of virtual machines to deploy. Map key is used as the VM name. See schema below |

### `vms` Object Schema

| Attribute | Type | Default | Required | Description |
|---|---|---|---|---|
| `template_name` | `string` | — | yes | Name of the VM template to clone |
| `datastore` | `string` | — | yes | Target datastore name |
| `vm_folder` | `string` | — | yes | vSphere folder path for the VM |
| `network` | `string` | — | yes | Port group / network name to attach |
| `num_cpus` | `number` | `2` | no | Number of vCPUs |
| `memory` | `number` | `4096` | no | RAM in MB |
| `disk_size` | `number` | — | yes | Disk size in GB |
| `base_tags` | `list(string)` | `[]` | no | NSX-T policy tag values to apply to the VM |

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
