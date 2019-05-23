variable "TERRAFORM_OPENSTACK_HDFS_NAMENODE_1_STATIC_IP" {}
variable "TERRAFORM_OPENSTACK_HDFS_DATANODE_1_STATIC_IP" {}
variable "TERRAFORM_OPENSTACK_HDFS_DATANODE_2_STATIC_IP" {}
variable "TERRAFORM_OPENSTACK_HDFS_DATANODE_3_STATIC_IP" {}

resource "openstack_networking_port_v2" "hdfs-private-radar-ip" {
  name               = "hdfs-private-radar-ip"
  network_id         = "${openstack_networking_network_v2.hdfs-private-network.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.radar-secgroup.id}"]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.hdfs-private-subnet.id}"
    "ip_address" = "192.168.200.10"
  }
}

resource "openstack_networking_port_v2" "hdfs-private-hdfs-namenode-1-ip" {
  name               = "hdfs-private-hdfs-namenode-1-ip"
  network_id         = "${openstack_networking_network_v2.hdfs-private-network.id}"
  admin_state_up     = "true"
  security_group_ids = [
    "${openstack_compute_secgroup_v2.radar-secgroup.id}",
    "${openstack_networking_secgroup_v2.hdfs-common.id}",
    "${openstack_networking_secgroup_v2.hdfs-namenode.id}" ]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.hdfs-private-subnet.id}"
    "ip_address" = "${var.TERRAFORM_OPENSTACK_HDFS_NAMENODE_1_STATIC_IP}"
  }
}

resource "openstack_networking_port_v2" "hdfs-private-hdfs-datanode-1-ip" {
  name               = "hdfs-private-hdfs-datanode-1-ip"
  network_id         = "${openstack_networking_network_v2.hdfs-private-network.id}"
  admin_state_up     = "true"
  security_group_ids = [    "${openstack_compute_secgroup_v2.radar-secgroup.id}",
      "${openstack_networking_secgroup_v2.hdfs-common.id}",
      "${openstack_networking_secgroup_v2.hdfs-datanode.id}" ]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.hdfs-private-subnet.id}"
    "ip_address" = "${var.TERRAFORM_OPENSTACK_HDFS_DATANODE_1_STATIC_IP}"
  }
}

resource "openstack_networking_port_v2" "hdfs-private-hdfs-datanode-2-ip" {
  name               = "hdfs-private-hdfs-datanode-2-ip"
  network_id         = "${openstack_networking_network_v2.hdfs-private-network.id}"
  admin_state_up     = "true"
  security_group_ids = [    "${openstack_compute_secgroup_v2.radar-secgroup.id}",
      "${openstack_networking_secgroup_v2.hdfs-common.id}",
      "${openstack_networking_secgroup_v2.hdfs-datanode.id}" ]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.hdfs-private-subnet.id}"
    "ip_address" = "${var.TERRAFORM_OPENSTACK_HDFS_DATANODE_2_STATIC_IP}"
  }
}

resource "openstack_networking_port_v2" "hdfs-private-hdfs-datanode-3-ip" {
  name               = "hdfs-private-hdfs-datanode-3-ip"
  network_id         = "${openstack_networking_network_v2.hdfs-private-network.id}"
  admin_state_up     = "true"
  security_group_ids = [
    "${openstack_compute_secgroup_v2.radar-secgroup.id}",
    "${openstack_networking_secgroup_v2.hdfs-common.id}",
    "${openstack_networking_secgroup_v2.hdfs-datanode.id}" ]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.hdfs-private-subnet.id}"
    "ip_address" = "${var.TERRAFORM_OPENSTACK_HDFS_DATANODE_3_STATIC_IP}"
  }
}
