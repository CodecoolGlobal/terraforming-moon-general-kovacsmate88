terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow-ssh-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["217.65.104.98/32"]
  }
}


resource "aws_instance" "example" {
  ami           = "ami-00aa9d3df94c6c354"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = "MYKEYEC2"

  tags = {
    Name = "My-Moon-EC2-insatnce"
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
