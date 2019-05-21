resource "openstack_networking_floatingip_v2" "hdfs-namenode-1" {
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "hdfs-datanode-1" {
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "hdfs-datanode-2" {
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "hdfs-datanode-3" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "hdfs-namenode-1-fp-associate" {
  floating_ip = "${openstack_networking_floatingip_v2.hdfs-namenode-1.address}"
  instance_id = "${openstack_compute_instance_v2.hdfs-namenode-1.id}"
}

resource "openstack_compute_floatingip_associate_v2" "hdfs-datanode-1-fp-associate" {
  floating_ip = "${openstack_networking_floatingip_v2.hdfs-datanode-1.address}"
  instance_id = "${openstack_compute_instance_v2.hdfs-datanode-1.id}"
}

resource "openstack_compute_floatingip_associate_v2" "hdfs-datanode-2-fp-associate" {
  floating_ip = "${openstack_networking_floatingip_v2.hdfs-datanode-2.address}"
  instance_id = "${openstack_compute_instance_v2.hdfs-datanode-2.id}"
}

resource "openstack_compute_floatingip_associate_v2" "hdfs-datanode-3-fp-associate" {
  floating_ip = "${openstack_networking_floatingip_v2.hdfs-datanode-3.address}"
  instance_id = "${openstack_compute_instance_v2.hdfs-datanode-3.id}"
}
