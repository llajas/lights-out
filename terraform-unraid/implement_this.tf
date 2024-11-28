# Define the storage pool
resource "libvirt_pool" "default_pool" {
  name = "default_pool"
  type = "dir"
  path = "/mnt/user/images/default_pool" # Adjust this path
}

# Define the VM volume
resource "libvirt_volume" "ubuntu_volume" {
  name   = "ubuntu2204.qcow2"
  pool   = libvirt_pool.default_pool.name
  source = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

# Define the network
resource "libvirt_network" "existing_network" {
  name      = "br0"
  mode      = "bridge"
  addresses = ["192.168.1.0/24"] # Adjust to your network
}

# Define the cloud-init disk
resource "libvirt_cloudinit_disk" "cloudinit" {
  name    = "cloudinit.iso"
  pool    = libvirt_pool.default_pool.name
  user_data = <<-EOT
    #cloud-config
    users:
      - name: yourusername
        ssh_authorized_keys:
          - ssh-rsa AAAAB3...your-ssh-key
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: sudo
        lock_passwd: false
        passwd: $6$rounds=4096$yourhashedpassword
  EOT
  network_config = <<-EOT
    version: 2
    ethernets:
      ens3:
        dhcp4: true
  EOT
}

# Define the virtual machine
resource "libvirt_domain" "ubuntu_vm" {
  name   = "ubuntu-vm"
  memory = 2048  # 2 GB RAM
  vcpu   = 2     # 2 vCPUs

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name = libvirt_network.existing_network.name
  }

  disk {
    volume_id = libvirt_volume.ubuntu_volume.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }
}
