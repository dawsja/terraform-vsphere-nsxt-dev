# ----------------------------
# vSphere Provider Variables
# ----------------------------

variable "vsphere_user" {
  description = "Username for authenticating to the vSphere API."
  type        = string
}

variable "vsphere_password" {
  description = "Password for authenticating to the vSphere API."
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "Hostname or IP address of the vCenter Server."
  type        = string
}

variable "vsphere_allow_unverified_ssl" {
  description = "Allow unverified SSL certificates when connecting to vSphere. Set to false in production."
  type        = bool
  default     = false
}

# ----------------------------
# NSX-T Provider Variables
# ----------------------------

variable "nsxt_host" {
  description = "Hostname or IP address of the NSX-T Manager."
  type        = string
}

variable "nsxt_username" {
  description = "Username for authenticating to the NSX-T API."
  type        = string
}

variable "nsxt_password" {
  description = "Password for authenticating to the NSX-T API."
  type        = string
  sensitive   = true
}

variable "nsxt_allow_unverified_ssl" {
  description = "Allow unverified SSL certificates when connecting to NSX-T. Set to false in production."
  type        = bool
  default     = false
}

# ----------------------------
# vSphere Infrastructure
# ----------------------------

variable "vsphere_datacenter" {
  description = "Name of the vSphere datacenter."
  type        = string
}

variable "vsphere_cluster" {
  description = "Name of the vSphere compute cluster."
  type        = string
}

# ----------------------------
# Virtual Machines
# ----------------------------

variable "vms" {
  description = "Map of virtual machines to deploy. The map key is used as the VM name."
  type = map(object({
    template_name = string
    datastore     = string
    vm_folder     = string
    network       = string
    num_cpus      = optional(number, 2)
    memory        = optional(number, 4096)
    disk_size     = number
    base_tags     = optional(list(string), [])
  }))
  default = {}
}
