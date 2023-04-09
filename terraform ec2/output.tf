output "apacheurl" {
  value = format("http://%s", aws_instance.ravi123.public_ip)
}

output "inventory_file" {
  value = data.template_file.inventory.rendered

}