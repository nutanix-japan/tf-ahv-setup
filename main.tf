terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">=1.2.0"
    }
  }
}

data "nutanix_cluster" "cluster" {
  name = var.cluster_name
}

provider "nutanix" {
  username     = var.user
  password     = var.password
  endpoint     = var.endpoint
  insecure     = true
  wait_timeout = 60
}


#. Setup AHV Networking - at least two networks

# resource "nutanix_subnet" "primary" {
#   name         = var.first_network_name
#   cluster_uuid = data.nutanix_cluster.cluster.id
#   vlan_id      = var.first_network_vlan_id
#   subnet_type  = "VLAN"

#   prefix_length              = var.first_network_prefix_length
#   default_gateway_ip         = var.first_network_default_gateway_ip
#   subnet_ip                  = var.first_network_subnet_ip
#   ip_config_pool_list_ranges = var.first_network_dhcp_range

#   dhcp_options = {
#     domain_name = var.first_network_domain_name
#   }
#   dhcp_domain_name_server_list = var.first_network_name_server_list
#   dhcp_domain_search_list      = var.first_network_domain_search_list
# }

# 2. Create new Storage Pool
# 3. Create new Storage Container
# 4. Upload PC image

# resource "nutanix_image" "pcimage" {
#   name        = "pcimage"
#   description = "pcimage in qcow format"
#   source_uri  = var.pcimage_uri
#   #source_path = 
#   depends_on = [
#     nutanix_subnet.primary
#   ]
# }

# resource "nutanix_image" "pcimage_boot" {
#   name        = "pcimage_boot"
#   description = "pcimage boot in qcow format"
#   source_uri  = var.pcimage_boot_uri
#   #source_path = 
#   depends_on = [
#     nutanix_subnet.primary
#   ]
# }

# resource "nutanix_image" "pcimage_data" {
#   name        = "pcimage_data"
#   description = "pcimage data in qcow format"
#   source_uri  = var.pcimage_data_uri
#   #source_path = 
#   depends_on = [
#     nutanix_subnet.primary
#   ]
# }

# resource "nutanix_image" "pcimage_home" {
#   name        = "pcimage_home"
#   description = "pcimage home in qcow format"
#   source_uri  = var.pcimage_home_uri
#   #source_path = 
#   depends_on = [
#     nutanix_subnet.primary
#   ]
# }
# # 5. Create PC VM

# resource "nutanix_virtual_machine" "pc" {
#   name                 = "PC"
#   cluster_uuid         = data.nutanix_cluster.cluster.id
#   num_vcpus_per_socket = "1"
#   num_sockets          = "4"
#   memory_size_mib      = 16 * 1024
#   disk_list {
#     device_properties {
#       device_type = "DISK"
#       disk_address = {
#         "adapter_type" = "SCSI"
#         "device_index" = "0"
#       }
#     }
#     data_source_reference = {
#       kind = "image"
#       uuid = nutanix_image.pcimage_boot.id
#     }
#   }

#   disk_list {
#     device_properties {
#       device_type = "DISK"
#       disk_address = {
#         "adapter_type" = "SCSI"
#         "device_index" = "1"
#       }
#     }
#     data_source_reference = {
#       kind = "image"
#       uuid = nutanix_image.pcimage_home.id
#     }
#   }

#   disk_list {
#     device_properties {
#       device_type = "DISK"
#       disk_address = {
#         "adapter_type" = "SCSI"
#         "device_index" = "2"
#       }
#     }
#     data_source_reference = {
#       kind = "image"
#       uuid = nutanix_image.pcimage_data.id
#     }
#   }

#   nic_list {
#     subnet_uuid = nutanix_subnet.primary.id
#   }
#   depends_on = [
#     nutanix_image.pcimage_home
#   ]
# }
# # 6. Connect PC to PE


