variable "TERRAFORM_OPENSTACK_RADAR_SUBNET" {
  default = ""
}
variable "TERRAFORM_OPENSTACK_RADAR_STATIC_IP" {
  default = ""
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
  security_group_ids = ["${openstack_compute_secgroup_v2.radar-secgroup.id}"]

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
  flavor_name     = "m1.large"
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
