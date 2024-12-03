# Define the storage pool
resource "libvirt_pool" "default_pool" {
  name = "default_pool"
  type = "dir"
  path = "/mnt/user/domains/default_pool" # Adjust this path to your needs - This points towards my SSD cache pool
}

# Base Image
resource "libvirt_volume" "ubuntu_volume" {
  name   = "ubuntu2204.qcow2"
  pool   = libvirt_pool.default_pool.name
  source = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

# Define the base volume
resource "libvirt_volume" "lights-out" {
  name           = "lights-out.qcow2"
  base_volume_id = libvirt_volume.ubuntu_volume.id
  pool   = libvirt_pool.default_pool.name
  size = 10 * 1024 * 1024 * 1024 # 10GB
}
