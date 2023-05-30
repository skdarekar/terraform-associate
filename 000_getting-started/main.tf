resource "aws_instance" "web" {
  ami           = "ami-0607784b46cbe5816"
  instance_type = var.instance_type
  tags = {
    Name = "HelloWorld ${local.project_name}"
  }
}
