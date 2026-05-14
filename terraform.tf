terraform {
  required_version = ">= 1.15.3"

  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "~> 2.16.0"
    }
    nsxt = {
      source  = "vmware/nsxt"
      version = "~> 3.11.1"
    }
  }
}
