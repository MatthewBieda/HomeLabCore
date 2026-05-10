variable "vms" {
  default = {
    master = { memory = 2048, vcpu = 2 }
    worker1 = { memory = 2048, vcpu = 2 }
    worker2 = { memory = 2048, vcpu = 2 }
  }
}

variable "base_image_path" {
  default = "/var/lib/libvirt/images/ubuntu24.04.qcow2"
}

variable "ansible_user" {
  default = "matt"
}
