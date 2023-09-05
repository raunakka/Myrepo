provider "aws" {
    region = "us-east-1"
    access_key="AKIAQ7DQI5TYCKJUU5E2"
    secret_key="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"
}

resource "aws_security_group" "web-server" {
    name        = "web-server"
    description = "Allow incoming HTTP Connections"
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "ec2" {
    count=2
    ami="ami-08a52ddb321b32a8c"
    instance_type="t2.micro"
    security_groups = ["${aws_security_group.web-server.name}"]
    user_data = <<-EOF
       #!/bin/bash
       sudo su
        yum update -y
        yum install httpd -y
        systemctl start httpd
        systemctl enable httpd
        echo "<html><h1> Welcome to Whizlabs. Happy Learning from $(hostname -f)...</p> </h1></html>" >> /var/www/html/index.html
        EOF
    tags = {
        Name = "instance-${count.index}"
    }    
}

data "aws_vpc" "default" {
    default = true
}

resource "aws_lb_target_group" "target_group" {
  name="tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb" "application-lb" {
    name            = "whiz-alb"
    internal        = false
    ip_address_type     = "ipv4"
    load_balancer_type = "application"
}

resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn          = aws_lb.application-lb.arn
    port                       = 80
    protocol                   = "HTTP"
    default_action {
        
        type                     = "forward"
    }
}

