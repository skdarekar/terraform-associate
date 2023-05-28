terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region     = "ap-south-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}

resource "aws_instance" "web" {
  ami           = "ami-0607784b46cbe5816"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}