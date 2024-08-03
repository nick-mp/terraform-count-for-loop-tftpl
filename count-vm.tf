data "yandex_compute_image" "ubuntu" {
  family = var.wm_web_img
}

resource "yandex_compute_instance" "web" {
  count      = var.vm_web_count
  name       = "vm-${count.index + 1}"
  zone       = var.default_zone
  depends_on = [yandex_compute_instance.each_vms]

  resources {
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

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = var.metadata

  scheduling_policy {
    preemptible = true
  }
}

