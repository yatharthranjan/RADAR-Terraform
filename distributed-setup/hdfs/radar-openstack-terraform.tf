variable "TERRAFORM_OPENSTACK_RADAR_SUBNET" {
  default = ""
}
variable "TERRAFORM_OPENSTACK_RADAR_STATIC_IP" {
  default = ""
}

variable "RADAR_BASE_DIRECTORY" {
  default = "/home/ubuntu/radar-cp-stack"
}

provider "openstack" {
  user_name   = ""
  tenant_name = ""
  password    = ""
  auth_url    = "http://localhost:10000/v3"
  region      = "regionOne"
  project_domain_id  = "default"
}

resource "openstack_networking_network_v2" "radar-network" {
  name           = "radar-network"
  admin_state_up = "true"
}

resource "openstack_networking_router_interface_v2" "radar-router-interface" {
  router_id = "${openstack_networking_router_v2.radar-router.id}"
  subnet_id = "${openstack_networking_subnet_v2.radar-subnet.id}"
}

resource "openstack_networking_subnet_v2" "radar-subnet" {
  name       = "myheathe-demo-subnet"
  network_id = "${openstack_networking_network_v2.radar-network.id}"
  cidr       = "${var.TERRAFORM_OPENSTACK_RADAR_SUBNET}"
  ip_version = 4
  dns_nameservers = ["8.8.8.8"]
}

resource "openstack_networking_port_v2" "radar-ip" {
  name               = "radar-ip"
  network_id         = "${openstack_networking_network_v2.radar-network.id}"
  admin_state_up     = "true"
  security_group_ids = [
    "${openstack_networking_secgroup_v2.radar-secgroup.id}",
    "${openstack_networking_secgroup_v2.hdfs-common.id}"
  ]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.radar-subnet.id}"
    "ip_address" = "${var.TERRAFORM_OPENSTACK_RADAR_STATIC_IP}"
  }
}

resource "openstack_networking_floatingip_v2" "radar-fp" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "radar-fp-associate" {
  floating_ip = "${openstack_networking_floatingip_v2.radar-fp.address}"
  instance_id = "${openstack_compute_instance_v2.radar.id}"
}

resource "openstack_compute_instance_v2" "radar" {
  name            = "radar"
  image_name      = "ubuntu-18.04"
  flavor_name     = "m1.xlarge"
  key_pair        = "CLOUD_ROSALIND"
  user_data       = "${data.template_cloudinit_config.cloudinit.rendered}"
  metadata = {
    this = "radar"
  }

  network {
    port = "${openstack_networking_port_v2.radar-ip.id}"
  }

  network {
    port = "${openstack_networking_port_v2.hdfs-private-radar-ip.id}"
  }
}

resource "null_resource" "radar-provision" {
  depends_on = ["openstack_compute_floatingip_associate_v2.radar-fp-associate"]
  connection {
    user = "ubuntu"
    host = "${openstack_compute_floatingip_associate_v2.radar-fp-associate.floating_ip}"
  }

  # First Create Keys locally so can be copied to remote. Backup the keystore to a safe place
  provisioner "local-exec" {
    command = "radar-cp-stack/bin/keystore-init"
  }

  # Inject Mac address to the network config script
  provisioner "local-exec" {
    command = <<EOS
      sed -i "" "s/macaddress:.*/macaddress: ${openstack_networking_port_v2.hdfs-private-radar-ip.mac_address}/g" scripts/add-network-interface.sh
      EOS
  }


  provisioner "file" {
    source      = "scripts/add-network-interface.sh"
    destination = "add-network-interface.sh"
  }

  provisioner "remote-exec" {
    inline =  [
      "chmod +x add-network-interface.sh",
      "sudo bash add-network-interface.sh",
      "sudo netplan apply"
    ]
  }

  # Remove the remote directory if it exists. This is the case when there is
  # only a provisioning change or the instance is tainted.
  provisioner "remote-exec" {
    inline = [
      <<EOS
          if [ -d '${var.RADAR_BASE_DIRECTORY}' ]; then
              sudo rm -r '${var.RADAR_BASE_DIRECTORY}'
          fi
      EOS
        ]
  }

  # Copy radar docker-compose stack
  provisioner "file" {
    source      = "radar-cp-stack"
    destination = "${var.RADAR_BASE_DIRECTORY}"
  }

  # Set permissions for executable files
  provisioner "remote-exec" {
    inline = [
      <<EOS
        find ${var.RADAR_BASE_DIRECTORY}/bin -type f -exec chmod +x {} \;
        find ${var.RADAR_BASE_DIRECTORY} -name "*.sh" -type f -exec chmod +x {} \;
      EOS
    ]
  }

  # Install and Run the stack
  # The sleep is required as to wait for the instance to finish start up
  provisioner "remote-exec" {
     inline = [
       "sleep 100",
       "sudo mkdir -p /usr/local/var/lib/docker",
       "cd ${var.RADAR_BASE_DIRECTORY}",
       "sudo bash ./bin/radar-docker install > radar-install-output.log 2>&1"
     ]
  }

  provisioner "remote-exec" {
    inline = "docker ps -a"
  }
}
