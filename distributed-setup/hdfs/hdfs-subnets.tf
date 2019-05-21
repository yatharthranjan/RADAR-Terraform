resource "openstack_networking_subnet_v2" "hdfs-private-subnet" {
  name       = "hdfs-private-subnet"
  network_id = "${openstack_networking_network_v2.hdfs-private-network.id}"
  cidr       = "192.168.200.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8"]
}
