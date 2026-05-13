terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "muhs-tfstate-ec2-demo-12345"
    key    = "ec2/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "sg" {
  name = "muhs-sg"

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "ec2" {
  ami           = "ami-04a8a2b994a2a7176"
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "muhs-ec2"
  }
}