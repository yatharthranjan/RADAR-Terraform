resource "openstack_compute_instance_v2" "hdfs-namenode-1" {
  name            = "hdfs-namenode-1"
  image_name      = "ubuntu-18.04"
  flavor_name     = "m1.small"
  key_pair        = "CLOUD_ROSALIND"
  user_data       = "${data.template_cloudinit_config.cloudinit.rendered}"
  metadata = {
    this = "hdfs"
  }

  network {
    port = "${openstack_networking_port_v2.hdfs-private-hdfs-namenode-1-ip.id}"
  }
}

resource "openstack_compute_instance_v2" "hdfs-datanode-1" {
  name            = "hdfs-datanode-1"
  image_name      = "ubuntu-18.04"
  flavor_name     = "m1.small"
  key_pair        = "CLOUD_ROSALIND"
  user_data       = "${data.template_cloudinit_config.cloudinit.rendered}"
  metadata = {
    this = "hdfs"
  }

  network {
    port = "${openstack_networking_port_v2.hdfs-private-hdfs-datanode-1-ip.id}"
  }
}

resource "openstack_compute_instance_v2" "hdfs-datanode-2" {
  name            = "hdfs-datanode-2"
  image_name      = "ubuntu-18.04"
  flavor_name     = "m1.small"
  key_pair        = "CLOUD_ROSALIND"
  user_data       = "${data.template_cloudinit_config.cloudinit.rendered}"
  metadata = {
    this = "hdfs"
  }

  network {
    port = "${openstack_networking_port_v2.hdfs-private-hdfs-datanode-2-ip.id}"
  }
}

resource "openstack_compute_instance_v2" "hdfs-datanode-3" {
  name            = "hdfs-datanode-3"
  image_name      = "ubuntu-18.04"
  flavor_name     = "m1.small"
  key_pair        = "CLOUD_ROSALIND"
  user_data       = "${data.template_cloudinit_config.cloudinit.rendered}"
  metadata = {
    this = "hdfs"
  }

  network {
    port = "${openstack_networking_port_v2.hdfs-private-hdfs-datanode-3-ip.id}"
  }
}
