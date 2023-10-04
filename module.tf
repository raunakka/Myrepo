provider aws {
    access_key="AKIAWXP6IE3QDV2UYPF4"
    secret_key="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"
    region="us-east-1"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"
  version = "5.5.0"
  ami                    = "ami-03a6eaae9938c858c"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  subnet_id              = "subnet-012c2bd004bbb27b2"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}