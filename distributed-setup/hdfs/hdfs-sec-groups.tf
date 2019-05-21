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
