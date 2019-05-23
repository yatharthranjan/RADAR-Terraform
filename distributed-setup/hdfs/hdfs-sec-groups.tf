resource "openstack_compute_secgroup_v2" "radar-secgroup" {
  name                 = "radar-ssh"
  description          = "Ingress ssh"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_secgroup_v2" "hdfs-common" {
  name        = "hdfs-common-secgroup"
  description = "Common seq group for all hdfs nodes"
}

resource "openstack_networking_secgroup_rule_v2" "hdfs-common-secgroup_rule_1" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.hdfs-common.id}"
}

resource "openstack_networking_secgroup_v2" "hdfs-datanode" {
  name        = "hdfs-datanode-secgroup"
  description = "Data node seq group for exposing datanodes"
}

resource "openstack_networking_secgroup_rule_v2" "hdfs-datanode-secgroup_rule_1" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "50010"
  port_range_max    = "50475"
  remote_ip_prefix  = "${var.TERRAFORM_OPENSTACK_HDFS_SUBNET}"
  security_group_id = "${openstack_networking_secgroup_v2.hdfs-datanode.id}"
}

resource "openstack_networking_secgroup_rule_v2" "hdfs-datanode-secgroup_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "50010"
  port_range_max    = "50475"
  remote_ip_prefix  = "${var.TERRAFORM_OPENSTACK_HDFS_SUBNET}"
  security_group_id = "${openstack_networking_secgroup_v2.hdfs-datanode.id}"
}

resource "openstack_networking_secgroup_v2" "hdfs-namenode" {
  name        = "hdfs-namenode-secgroup"
  description = "Name node seq group for exposing namenode ports"
}

resource "openstack_networking_secgroup_rule_v2" "hdfs-namenode-secgroup_rule_1" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "8020"
  port_range_max    = "9870"
  remote_group_id   = "${openstack_networking_secgroup_v2.hdfs-datanode.id}"
  security_group_id = "${openstack_networking_secgroup_v2.hdfs-namenode.id}"
}

resource "openstack_networking_secgroup_rule_v2" "hdfs-namenode-secgroup_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "8020"
  port_range_max    = "9870"
  remote_group_id   = "${openstack_networking_secgroup_v2.hdfs-datanode.id}"
  security_group_id = "${openstack_networking_secgroup_v2.hdfs-namenode.id}"
}
