terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sagar_darekar"

    workspaces {
      name = "my-app-prod"
    }
  }
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
  alias      = "eu"
}