# 1. Search for a standard, free Amazon Linux 2023 image
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# 2. Deploy the instance and install Nginx automatically
resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type # Fits in Free Tier if you use t2.micro/t3.micro

  # This script runs once the server starts to install and start Nginx
  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install -y nginx
              sudo systemctl enable --now nginx
              EOF

  tags = {
    Name = "MyFreeNginxServer"
  }
}
