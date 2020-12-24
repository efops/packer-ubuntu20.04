variable datacenter {
  type = string
  description = "Required if there is more than one datacenter in vCenter."
  default = " "
}

variable datastore {
  type = string
  description = "Required for clusters, or if the target host has multiple datastores."
  default = " "
}

variable disk_controller_type {
  type = string
  description = "The virtual disk controller type."
  default = "pvscsi"
}

variable folder {
  type = string
  description = "The VM folder in which the VM template will be created."
  default = "Templates"
}

variable host {
  type = string
  description = "The ESXi host where target VM is created."
  default = " "
}

variable http_directory {
  type = string
  description = "Directory of config files(user-data, meta-data)."
  default = "http"
}

variable insecure_connection {
  type = bool
  description = "If true, does not validate the vCenter server's TLS certificate."
  default = true
}

variable iso_filename {
  type = string
  description = "The file name of the guest operating system ISO image installation media."
  # https://releases.ubuntu.com/20.04/ubuntu-20.04.1-live-server-amd64.iso
  default = "ubuntu-20.04.1-live-server-amd64.iso"
}

variable network {
  type = string
  description = "The network segment or port group name to which the primary virtual network adapter will be connected."
  default = " "
}

variable password {
  type = string
  description = "The plaintext password for authenticating to vCenter."
  default = " "
}

variable ssh_password {
  type = string
  description = "The plaintext password to use to authenticate over SSH."
  default = "ubuntu"
}

variable ssh_username {
  type = string
  description = "The username to use to authenticate over SSH."
  default = "ubuntu"
}

variable username {
  type = string
  description = "The username for authenticating to vCenter."
  default = " "
}

variable vcenter_server {
  type = string
  description = "The vCenter server hostname, IP, or FQDN."
  default = " "
}

variable vm_name {
  type = string
  description = "The name of the new VM template to create."
  default = "Ubuntu-20.04"
}

variable vm_version {
  type = number
  description = "The VM virtual hardware version."
  # https://kb.vmware.com/s/article/1003746
  default = 14
}

locals {
  iso_path = "[${var.datastore}] /packer_cache/${var.iso_filename}"
  vm_name = "${var.vm_name}-${formatdate("YYYYMMDD'T'hhmmss", timestamp())}Z"
}

source vsphere-iso ubuntu-server {
  CPUs = 2
  RAM = 2048
  RAM_reserve_all = true
  boot_command = [
    "<esc><esc><esc>",
    "<enter><wait>",
    "/casper/vmlinuz ",
    "root=/dev/sr0 ",
    "initrd=/casper/initrd ",
    "autoinstall ",
    "ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter>"
  ]
  boot_wait = "2s"
  convert_to_template = true
  datacenter = var.datacenter
  datastore = var.datastore
  disk_controller_type = [
    var.disk_controller_type,
  ]
  folder = var.folder
  guest_os_type = "ubuntu64Guest"
  host = var.host
  http_directory = var.http_directory
  insecure_connection = var.insecure_connection
  iso_paths = [
    local.iso_path,
  ]
  network_adapters {
    network = var.network
    network_card = "vmxnet3"
  }
  notes = "Default SSH User: {{`var.username`}}\nDefault SSH Pass: {{`var.password`}}\nBuilt by Packer @ {{isotime \"2006-01-02 03:04\"}}."
  password = var.password
  ssh_password = var.ssh_password
  ssh_timeout = "20m"
  ssh_handshake_attempts = "100000"
  ssh_username = var.ssh_username
  storage {
    disk_size = 20000
    disk_thin_provisioned = true
  }
  username = var.username
  vcenter_server = var.vcenter_server
  vm_name = local.vm_name
  vm_version = var.vm_version
}

build {
  sources = ["source.vsphere-iso.ubuntu-server"]

  provisioner "shell" {
    execute_command = "echo 'ubuntu' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    scripts = [
      "./scripts/setup_ubuntu2004.sh",
    ]
  }
}
