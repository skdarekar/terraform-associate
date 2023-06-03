terraform {
  cloud {
    organization = "sagar_darekar"

    workspaces {
      name = "provisioners"
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
  region = "ap-south-1"
}

data "aws_vpc" "main" {
  id = "vpc-0a5e8e56617d89238"
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "My Server Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["135.234.234.65/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAu7mHZnZZluVbIN0aN863T6zZ80E8rUslsjnenByJt0uLsqgqB0x0lGo4/zfl7jY5KA/TJwhn/R+R/Z7z+KGtfBSbB9F3PFGAiyORrXQZ6Jgkqwi1V2gmCn9IU3KL2oRPSWS2xiCsYZAMxFa4kAUz0ahXFcvYklDi5cnVb+/oSUSm3Ka1ZFDSSN5YQBZmC6HyzFgSVu2TiLoiNfWfSrrCDWuwQRrTTPhv+FZ91N+4ZBWazyau5vqtArngxxr/O+2q7OT5DpeD+HBDx01QzOKh5o3aNwKtlLSU6g9JzbKtRJASNwu+/xixUJQLgxbWlifHo+rvVGM7CSQKwebpXQBn root@L-BMRSVM3"
}

data "template_file" "user_data" {
  template = file("./user-data.yml")
}

resource "aws_instance" "web" {
  ami                    = "ami-0607784b46cbe5816"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data              = data.template_file.user_data.rendered
  tags = {
    Name = "HelloWorld"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}