variable "AWS_ACCESS_KEY_ID" {}

variable "AWS_SECRET_ACCESS_KEY" {}

variable "vpc_region" {
  description = "Region for the VPC"
  default = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "172.16.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "172.16.1.0/24"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "public_key"
}

variable "vpc_name" {
  description = "Name for the vpc"
  default = "vpc-ah-bird-box"
}

variable "bastion_ami" {
  description = "Bastion AMI"
  default = "ami-07dc734dc14746eab"
}

variable "nat_ami" {
  description = "NAT AMI"
  default = "ami-0ca65a55561666293"
}