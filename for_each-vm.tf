resource "yandex_compute_instance" "each_vms" {
  for_each                  = toset(var.each_vm_count)
  name                      = "gnn-${each.key}"
  zone                      = var.default_zone
  allow_stopping_for_update = true

  resources {
    cores         = "${each.value}" == "main" ? var.each_vm.0.cpu : var.each_vm.1.cpu
    memory        = "${each.value}" == "main" ? var.each_vm.0.memory : var.each_vm.1.memory
    core_fraction = "${each.value}" == "main" ? var.each_vm.0.core_fraction : var.each_vm.1.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = "${each.value}" == "main" ? var.each_vm.0.hdd_size : var.each_vm.1.hdd_size
      type     = "${each.value}" == "main" ? var.each_vm.0.hdd_type : var.each_vm.1.hdd_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = {
    user-data = file("~/.ssh/id_ed25519.pub")
  }

  scheduling_policy {
    preemptible = true
  }
}

