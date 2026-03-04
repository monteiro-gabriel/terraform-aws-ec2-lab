resource "local_file" "ansible_inventory" {
  filename = "${path.module}/hosts.yml"
  content  = <<-EOT
[terraform_ansible]
${aws_instance.app_server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/gabriel/Documents/Keys/gabriel.monteiro.pem
EOT
}