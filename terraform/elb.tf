# Create a load balancer for the frontend
resource "aws_elb" "public" {
  name = "${var.vpc_name}-elb-public"
  internal = false
  security_groups = ["${aws_security_group.elb-public.id}"]
  subnets = ["${aws_subnet.public-subnet.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 10
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:80/"
    interval = 30
  }

  instances = ["${aws_instance.frontend.id}"]
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 300

  tags = {
    Name = "${var.vpc_name}-elb-public"
  }
}

# Create a load balancer for the api
resource "aws_elb" "private" {
  name = "${var.vpc_name}-elb-private"
  internal = true
  security_groups = ["${aws_security_group.elb-private.id}"]
  subnets = ["${aws_subnet.private-subnet.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 10
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:80/"
    interval = 30
  }

  instances = ["${aws_instance.api.id}"]
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 300

  tags = {
    Name = "${var.vpc_name}-elb-private"
  }
}
