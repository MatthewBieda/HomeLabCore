variable "vm_name" {
  default = "tf-vm1"
}

variable "memory" {
  default = 2048
}

variable "vcpu" {
  default = 2
}

variable "base_image_path" {
  default = "/var/lib/libvirt/images/ubuntu24.04.qcow2"
}

variable "ansible_user" {
  default = "matt"
}
