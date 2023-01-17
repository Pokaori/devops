terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
        default = "us-east-1"
}

provider "aws" {
  region     = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_security_group" "ingress-all-test" {
  name = "allow-all-sg-2"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }// Terraform removes the default rule
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
    ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
  }// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}


resource "aws_key_pair" "deployer" {
  key_name   = "devops"
  public_key = file("~/.ssh/devops.pub")
}

resource "aws_instance" "app_server" {
  ami             = "ami-0b93ce03dcbcb10f6"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.id
  vpc_security_group_ids = ["${aws_security_group.ingress-all-test.id}"]

  tags = {
    Name = "ExampleAppServerInstance"
  }
  user_data = file("ubuntu.sh")
}