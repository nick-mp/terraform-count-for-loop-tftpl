resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",

  { web = yandex_compute_instance.web })

  filename = "${abspath(path.module)}/hosts.ini"
}



resource "local_file" "hosts_for" {
  content  = <<-EOT
  %{if length(yandex_compute_instance.each_vms) > 0}
  [each_vms]
  %{for i in yandex_compute_instance.each_vms}
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}    fqdn=${i["fqdn"]}
  %{endfor}
  %{endif}
  %{if length(yandex_compute_instance.web) > 0}
  [web]
  %{for i in yandex_compute_instance.web}
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}    fqdn=${i["fqdn"]}
  %{endfor}
  %{endif}
  [storage]
  %{if length(yandex_compute_instance.storage) > 0}
  %{for i in yandex_compute_instance.storage}
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}    fqdn=${i["fqdn"]}
  %{endfor}
  %{endif}
  EOT
  filename = "${abspath(path.module)}/for.ini"
}