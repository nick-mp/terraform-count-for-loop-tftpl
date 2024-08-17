
locals {

  output_web  = yandex_compute_instance.web
  output_each = yandex_compute_instance.each_vms

}


output "that_web_each" {
  value = <<-EOT
  [
  %{for i in local.output_web~}
    {
        name: ${i["name"]}
        id:   ${i["id"]}
        fqdn: ${i["fqdn"]}
      },

  %{endfor~}
  %{for i in local.output_each~}
    {
        name: ${i["name"]}
        id:   ${i["id"]}
        fqdn: ${i["fqdn"]}
      },

  %{endfor~}
  ]
  EOT
}
