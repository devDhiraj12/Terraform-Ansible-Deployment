# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  # filter {
  #   name   = "name"
  #   values = ["Amazon Linux 2023 AMI 2023.5.20240730.0 x86_64 HVM kernel-6.1"]
  # }
  
  # filter {
  #   name   = "virtualization-type"
  #   values = ["hvm"]
  # }
}

data "template_file" "userdata" {
  template = <<-EOF
              #!/bin/bash
              sudo yum update -y && sudo yum upgrade -y
              EOF
}


