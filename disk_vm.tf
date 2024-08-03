resource "yandex_compute_disk" "storage_disk" {
  count = var.disk_count
  size  = 1
}

resource "yandex_compute_instance" "storage" {
  count = 1
  name  = "storage"
  zone  = var.default_zone

  resources { # т.к. требований к ресурсам нет переиспользовал их из 2.1
    cores         = var.web_vm.cpu
    memory        = var.web_vm.memory
    core_fraction = var.web_vm.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.web_vm.hdd_size
      type     = var.web_vm.hdd_type
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk.*.id
    content {
      disk_id = yandex_compute_disk.storage_disk["${secondary_disk.key}"].id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  scheduling_policy {
    preemptible = true
  }
}

