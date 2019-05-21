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
  cidr       = "192.168.199.0/24"
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
    "ip_address" = "192.168.199.10"
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
  image_name      = "centos7"
  flavor_name     = "m1.small"
  key_pair        = "CLOUD_ROSALIND"
  metadata = {
    this = "network demo"
  }

  network {
    port = "${openstack_networking_port_v2.radar-ip.id}"
  }

  network {
    port = "${openstack_networking_port_v2.hdfs-private-radar-ip.id}"
  }
}
