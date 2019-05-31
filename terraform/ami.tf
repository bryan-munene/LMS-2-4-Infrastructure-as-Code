data "aws_ami" "ah-birdbox-db" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ah-birdbox-db"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
}

data "aws_ami" "ah-birdbox-api" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ah-birdbox-api"] 
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
}

data "aws_ami" "ah-birdbox-frontend" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ah-birdbox-frontend"] 
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
}

data "aws_ami" "ah-birdbox-nat" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
  
  owners = ["amazon"]
}
