terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "us-east-2"
}

# (Opcional) você pode remover este data source se não for usar Ubuntu agora
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server" {
  ami           = "ami-09256c524fab91d36"
  instance_type = "t2.micro"

  key_name               = "gabriel.monteiro"
  subnet_id              = "subnet-0f0f914f1878ae8f6"
  vpc_security_group_ids = ["sg-07f9c6e061f09f02b"]

  user_data = <<-EOF
#!/bin/bash
set -e

${file("user_data.sh")}

mkdir -p /opt/site

cat <<'HTML' > /opt/site/index.html
${file("index.html")}
HTML

docker rm -f site 2>/dev/null || true
docker run -d --name site -p 80:80 \
  -v /opt/site:/usr/share/nginx/html:ro nginx:latest
EOF

  tags = {
    Name = "teste-tf-monteiro"
  }
}