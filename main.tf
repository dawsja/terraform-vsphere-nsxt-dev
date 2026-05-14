# ---------------------------------------------------------------------------
# main.tf
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# vSphere Tag Creation for "Manged by Terraform"
# ---------------------------------------------------------------------------

resource "vsphere_tag_category" "automation" {
  name        = "Automation"
  cardinality = "MULTIPLE"

  associable_types = [
    "VirtualMachine",
  ]
}

resource "vsphere_tag" "managed_by_terraform" {
  name        = "Terraform Managed"
  category_id = vsphere_tag_category.automation.id
}

# ---------------------------------------------------------------------------
# vSphere Data Sources
# ---------------------------------------------------------------------------

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  for_each      = var.vms
  name          = each.value.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  for_each      = var.vms
  name          = each.value.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  for_each      = var.vms
  name          = each.value.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# ---------------------------------------------------------------------------
# Virtual Machine Deployment
# ---------------------------------------------------------------------------

resource "vsphere_virtual_machine" "vm" {
  for_each = var.vms

  name             = each.key
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore[each.key].id
  folder           = each.value.vm_folder
  num_cpus         = each.value.num_cpus
  memory           = each.value.memory
  guest_id         = data.vsphere_virtual_machine.template[each.key].guest_id
  tags             = [vsphere_tag.managed_by_terraform.id]

  network_interface {
    network_id   = data.vsphere_network.network[each.key].id
    adapter_type = data.vsphere_virtual_machine.template[each.key].network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = each.value.disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template[each.key].disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template[each.key].disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.key].id
  }
}

# ---------------------------------------------------------------------------
# NSX-T VM Tags
# ---------------------------------------------------------------------------

resource "nsxt_policy_vm_tags" "vm" {
  for_each = {
    for name, vm in var.vms : name => vm
    if length(vm.base_tags) > 0
  }

  instance_id = vsphere_virtual_machine.vm[each.key].id

  dynamic "tag" {
    for_each = each.value.base_tags

    content {
      scope = ""
      tag   = tag.value
    }
  }
}
