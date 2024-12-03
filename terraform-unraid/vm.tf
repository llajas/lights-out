# Define the virtual machine
resource "libvirt_domain" "ubuntu_vm" {
  name   = "lte-failover"
  memory = 2048  # 2 GB RAM
  vcpu   = 2     # 2 vCPUs
  qemu_agent = false

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
   bridge = "br0.137"
   hostname = "lte-failover"
  }

  disk {
    volume_id = libvirt_volume.lights-out.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    listen_address = "0.0.0.0"
    websocket = -1
  }

  xml {
    xslt = file("${path.module}/xslt/usbHub.xsl")
  }
}
