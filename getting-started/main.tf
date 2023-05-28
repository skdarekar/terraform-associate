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

provider "aws" {
  region     = "eu-west-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  alias = "eu"
}

variable "instance_type" {
  type = string
}

locals {
  project_name = "terraform-associate"
}

resource "aws_instance" "web" {
  ami           = "ami-0607784b46cbe5816"
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld ${local.project_name}"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  providers = {
    aws = aws.eu
  }
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
