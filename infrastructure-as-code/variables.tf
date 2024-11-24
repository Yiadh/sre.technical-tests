variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.0.2.0/24"
}

variable "ec2_ami" {
  default = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
}

variable "ec2_instance_type" {
  default = "t2.micro"
}
