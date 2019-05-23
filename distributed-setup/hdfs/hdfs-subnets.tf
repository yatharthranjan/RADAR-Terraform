variable "TERRAFORM_OPENSTACK_HDFS_SUBNET" {
  default = ""
}

resource "openstack_networking_subnet_v2" "hdfs-private-subnet" {
  name       = "hdfs-private-subnet"
  network_id = "${openstack_networking_network_v2.hdfs-private-network.id}"
  cidr       = "${var.TERRAFORM_OPENSTACK_HDFS_SUBNET}"
  ip_version = 4
  dns_nameservers = ["8.8.8.8"]
}
