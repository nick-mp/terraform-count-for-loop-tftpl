resource "random_password" "each" {
  for_each = toset([for k, v in yandex_compute_instance.web : v.name])
  length   = 17

}