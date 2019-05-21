variable "HDFS_BASE_DIRECTORY" {}

resource "null_resource" "hdfs-namenode-1-provision" {
  depends_on = ["openstack_compute_floatingip_associate_v2.hdfs-namenode-1-fp-associate"]
  connection {
    user = "ubuntu"
    host = "${openstack_compute_floatingip_associate_v2.hdfs-namenode-1-fp-associate.floating_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      <<EOS
      if [ ! -d '${var.HDFS_BASE_DIRECTORY}' ]; then
          mkdir '${var.HDFS_BASE_DIRECTORY}'
       fi
      EOS
    ]
  }

  provisioner "file" {
    source      = "hdfs-compose.yml"
    destination = "${var.HDFS_BASE_DIRECTORY}/hdfs-compose.yml"
  }

  provisioner "file" {
    source      = ".env"
    destination = "${var.HDFS_BASE_DIRECTORY}/.env"
  }

  provisioner "file" {
    source      = "images"
    destination = "${var.HDFS_BASE_DIRECTORY}/"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${var.HDFS_BASE_DIRECTORY} && docker-compose -f hdfs-compose.yml up -d hdfs-namenode-1"
    ]
  }
}


resource "null_resource" "hdfs-datanode-1-provision" {
  depends_on = ["openstack_compute_floatingip_associate_v2.hdfs-datanode-1-fp-associate"]
  connection {
    user = "ubuntu"
    host = "${openstack_compute_floatingip_associate_v2.hdfs-datanode-1-fp-associate.floating_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      <<EOS
      if [ ! -d '${var.HDFS_BASE_DIRECTORY}' ]; then
          mkdir '${var.HDFS_BASE_DIRECTORY}'
       fi
      EOS
    ]
  }

  provisioner "file" {
    source      = "hdfs-compose.yml"
    destination = "${var.HDFS_BASE_DIRECTORY}/hdfs-compose.yml"
  }

  provisioner "file" {
    source      = ".env"
    destination = "${var.HDFS_BASE_DIRECTORY}/.env"
  }

  provisioner "file" {
    source      = "images"
    destination = "${var.HDFS_BASE_DIRECTORY}/"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${var.HDFS_BASE_DIRECTORY} && docker-compose -f hdfs-compose.yml up -d hdfs-datanode-1"
    ]
  }
}


resource "null_resource" "hdfs-datanode-2-provision" {
  depends_on = ["openstack_compute_floatingip_associate_v2.hdfs-datanode-2-fp-associate"]
  connection {
    user = "ubuntu"
    host = "${openstack_compute_floatingip_associate_v2.hdfs-datanode-2-fp-associate.floating_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      <<EOS
      if [ ! -d '${var.HDFS_BASE_DIRECTORY}' ]; then
          mkdir '${var.HDFS_BASE_DIRECTORY}'
       fi
      EOS
    ]
  }

  provisioner "file" {
    source      = "hdfs-compose.yml"
    destination = "${var.HDFS_BASE_DIRECTORY}/hdfs-compose.yml"
  }

  provisioner "file" {
    source      = ".env"
    destination = "${var.HDFS_BASE_DIRECTORY}/.env"
  }

  provisioner "file" {
    source      = "images"
    destination = "${var.HDFS_BASE_DIRECTORY}/"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${var.HDFS_BASE_DIRECTORY} && docker-compose -f hdfs-compose.yml up -d hdfs-datanode-2"
    ]
  }
}

resource "null_resource" "hdfs-datanode-3-provision" {
  depends_on = ["openstack_compute_floatingip_associate_v2.hdfs-datanode-3-fp-associate"]
  connection {
    user = "ubuntu"
    host = "${openstack_compute_floatingip_associate_v2.hdfs-datanode-3-fp-associate.floating_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      <<EOS
      if [ ! -d '${var.HDFS_BASE_DIRECTORY}' ]; then
          mkdir '${var.HDFS_BASE_DIRECTORY}'
       fi
      EOS
    ]
  }

  provisioner "file" {
    source      = "hdfs-compose.yml"
    destination = "${var.HDFS_BASE_DIRECTORY}/hdfs-compose.yml"
  }

  provisioner "file" {
    source      = ".env"
    destination = "${var.HDFS_BASE_DIRECTORY}/.env"
  }

  provisioner "file" {
    source      = "images"
    destination = "${var.HDFS_BASE_DIRECTORY}/"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${var.HDFS_BASE_DIRECTORY} && docker-compose -f hdfs-compose.yml up -d hdfs-datanode-3"
    ]
  }
}
