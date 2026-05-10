terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "disk" {
  for_each = var.vms

  name = "tf-${each.key}.qcow2"
  pool = "default"
  target = {
    format = {
      type = "qcow2"
    }
  }
  create = {
    content = {
      url = "file://${var.base_image_path}"
    }
  }
}

resource "libvirt_domain" "vm" {
  for_each = var.vms

  name        = "tf-${each.key}"
  type        = "kvm"
  memory      = each.value.memory
  memory_unit = "MiB"
  vcpu        = each.value.vcpu
  running     = true

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    boot_devices = [
      { dev = "hd" }
    ]
  }

  devices = {
    disks = [
      {
        driver = {
          name = "qemu"
          type = "qcow2"
        }
        source = {
          file = {
            file = libvirt_volume.disk[each.key].path
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      }
    ]
    interfaces = [
      {
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = "default"
          }
        }
        wait_for_ip = {
          timeout = 300
          source  = "lease"
        }
      }
    ]
  }
}

data "libvirt_domain_interface_addresses" "vm" {
  for_each = var.vms

  domain = libvirt_domain.vm[each.key].name
  source = "lease"
}

output "vm_ips" {
  value = {
    for k, v in data.libvirt_domain_interface_addresses.vm :
    k => v.interfaces[0].addrs[0].addr
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    vms          = { for k, v in data.libvirt_domain_interface_addresses.vm : k => v.interfaces[0].addrs[0].addr }
    ansible_user = var.ansible_user
  })
  filename = "${path.module}/../ansible/inventory.ini"
}
