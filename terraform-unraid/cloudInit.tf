# Define the cloud-init disk
resource "libvirt_cloudinit_disk" "cloudinit" {
  name    = "cloudinit.iso"
  pool    = libvirt_pool.default_pool.name
  user_data = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/config/network_config.cfg")
}
