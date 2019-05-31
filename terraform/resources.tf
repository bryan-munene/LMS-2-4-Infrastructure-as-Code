# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "terraform"
  public_key = "${file("${var.key_path}")}"
}

# Define webserver inside the public subnet
resource "aws_instance" "frontend" {
   ami  = "${data.aws_ami.ah-birdbox-frontend.id}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.front-end.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   
  tags {
    Name = "${var.vpc_name}-ec2-front-end"
  }
}

# Define bastion host inside the public subnet
resource "aws_instance" "bastion" {
   ami  = "${var.bastion_ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   
  tags {
    Name = "${var.vpc_name}-ec2-bastion"
  }
}

# Define database inside the private subnet
resource "aws_instance" "database" {
   ami  = "${data.aws_ami.ah-birdbox-db.id}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.database.id}"]
   source_dest_check = false

  tags {
    Name = "${var.vpc_name}-ec2-database"
  }
}

# Define API inside the private subnet
resource "aws_instance" "api" {
   ami  = "${data.aws_ami.ah-birdbox-api.id}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.api.id}"]
   source_dest_check = false

  tags {
    Name = "${var.vpc_name}-ec2-API"
  }
}

# Launch NAT instance
resource "aws_instance" "nat" {
    ami  = "${data.ah-birdbox-nat.id}"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.default.id}"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.public-subnet.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "${var.vpc_name}-nat-instance"
    }
}

# Create an elastic IP
resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}

