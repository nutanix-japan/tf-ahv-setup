
## VM with key insertion

data "nutanix_image" "myimage" {
  image_name = "CentOS-PHX-DFS"
}

data "nutanix_subnet" "Primary" {
  subnet_name = "Primary"
}

data "template_file" "nonipam" {
  template = file("cloud-init.conf")
  vars = {
    ssh_keys = "${file(var.ssh_key_location)}"
    name     = "linux-non-ipam"
  }
}

resource "nutanix_image" "centoscloudimage" {
  name        = "centoscloudimage"
  description = "centoscloudimage in qcow format"
  source_uri  = "https://cloud.centos.org/altarch/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
}

resource "nutanix_virtual_machine" "testvmwithkey" {
  name                 = "testvmwithkey"
  num_vcpus_per_socket = "2"
  num_sockets          = 1
  memory_size_mib      = 4096
  cluster_uuid         = data.nutanix_cluster.cluster.id
  nic_list {
    subnet_uuid = data.nutanix_subnet.Primary.id

  }

  #   disk_list {
  #     data_source_reference = {
  #       kind = "image"
  #       uuid = nutanix_image.centoscloudimage.id
  #     }
  #   }
  disk_list {
    device_properties {
      device_type = "DISK"
      disk_address = {
        "adapter_type" = "SCSI"
        "device_index" = "1"
      }
    }
    data_source_reference = {
      kind = "image"
      uuid = nutanix_image.centoscloudimage.id
    }
  }
  guest_customization_cloud_init_user_data = base64encode(data.template_file.nonipam.rendered)

}

