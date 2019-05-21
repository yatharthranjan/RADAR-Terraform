resource "openstack_networking_network_v2" "hdfs-private-network" {
  name           = "hdfs-private network"
  admin_state_up = "true"
}
