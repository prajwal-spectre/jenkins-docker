provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "deployment_sg" {
  name        = "deployment_sg"
  description = "Security group for deployment server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "deployment" {
  ami           = "ami-04a81a99f5ec58529" # Ubuntu Server 20.04 LTS AMI ID for us-east-1 (N. Virginia)
  instance_type = "t2.micro"
  security_groups = [aws_security_group.deployment_sg.name]

user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt install apt-transport-https ca-certificates curl software-properties-common -y              sudo systemctl start docker
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
              apt-cache policy docker-ce
              sudo apt install docker-ce -y           
              sudo systemctl enable docker

              sudo docker pull your-dockerhub-rajjo103/pythonapp:latest
              sudo docker run -d -p 8081:5000 rajjo103/pythonapp:latest
              EOF


  tags = {
    Name = "deployment"
  }
}

data "aws_vpc" "default" {
  default = true
}

