resource "openstack_networking_router_v2" "radar-router" {
  name                = "radar-router"
  admin_state_up      = true
  external_network_id = "f64d9ac2-a192-41fc-97d7-f6d067b40bf9"
}

resource "openstack_networking_router_interface_v2" "hdfs-private-router-interface" {
  router_id = "${openstack_networking_router_v2.radar-router.id}"
  subnet_id = "${openstack_networking_subnet_v2.hdfs-private-subnet.id}"
}
