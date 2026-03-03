dnf update -y
dnf install -y docker
systemctl enable docker
systemctl start docker
docker rm -f site 2>/dev/null || true
docker run -d --name site -p 80:80 nginx:latest