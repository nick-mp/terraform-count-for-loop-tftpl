###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

#-------------var VM-----------------------

variable "vm_web_count" {
  type        = number
  default     = 2
  description = "web VMs count"
}

variable "wm_web_img" {
  type    = string
  default = "ubuntu-2404-lts-oslogin"
}

variable "metadata" {
  type = object({
    serial-port-enable = number,
    ssh-keys           = string
  })
  description = "ssh-keys"
}

variable "web_vm" {
  type = object({
    cpu           = number
    memory        = number
    core_fraction = number
    hdd_type      = string
    hdd_size      = number
  })
  default = {
    cpu           = 2
    memory        = 2
    core_fraction = 5
    hdd_type      = "network-hdd"
    hdd_size      = 10
  }
  description = "VMs resources"
}

#--------------------each VMs-----------------------

variable "each_vm_count" {
  type        = tuple([string, string])
  default     = ["main", "replica"]
  description = "each VMs count"
}

variable "each_vm" {
  type = list(object({
    cpu           = number
    memory        = number
    core_fraction = number
    hdd_type      = string
    hdd_size      = number
  }))
  default = [
    {
      cpu           = 2
      memory        = 1
      core_fraction = 5
      hdd_type      = "network-hdd"
      hdd_size      = 20
    },
    {
      cpu           = 2
      memory        = 2
      core_fraction = 20
      hdd_type      = "network-hdd"
      hdd_size      = 10
    }
  ]
  description = "VMs resources"
}

#-------------disk var----------------

variable "disk_count" {
  type        = number
  default     = 3
  description = "count of disks for storage"
}

variable "disk_replica" {
  type = list(object({
    type = string
  }))
  default = [{
    type = "network-hdd"
  }]
}

