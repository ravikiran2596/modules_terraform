output "apacheurl" {
  value = format("http://%s", aws_instance.ravi123.public_ip)
}

