resource "aws_iam_instance_profile" "swann_infra_bastion" {
  name = "swann-infra-bastion"
  role = aws_iam_role.swann_infra_bastion.name
}

resource "aws_iam_role" "swann_infra_bastion" {
  name = "swann-infra-bastion"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_instance" "swann_infra_bastion" {
  ami           = "ami-0b827f3319f7447c6" // ap-northeast-2
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.swann_infra_bastion.id

  key_name = "swann"

  vpc_security_group_ids = [aws_security_group.swann_infra_bastion.id]
}

resource "aws_security_group" "swann_infra_bastion" {
  name        = "swann-infra-bastion"
  description = "swann infra bastion instance sg"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "bastion_to_main_db" {
  description       = "Allow bastion instance connection"
  security_group_id = aws_security_group.main_db.id

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.swann_infra_bastion.id
}

resource "aws_security_group_rule" "ssh_to_bastion" {
  description       = "Allow SSH connections to bastion instance"
  security_group_id = aws_security_group.swann_infra_bastion.id

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_egress_all" {
  description       = "Egress"
  security_group_id = aws_security_group.swann_infra_bastion.id

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_key_pair" "swann" {
  key_name   = "swann"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy+PoTyFYq76ztU/8OwUsH/nNeIwpn/eIGW/cEMZDTeKzvikds1GF6gluymQecuSlFbyp9SeEOPIcE2YllkkFT0Bw/N/Lm9DSGeHzDrXLr8zG3W4MtPEYLElyQu+WIvazqwF2FmDFNOFt41lfHYLyPvem3QX0h8UJYcm1ZJVIryhbfkzoWhmVLmz3TKJWwL5icLgrRwKvr4D9YY9VZnl8ZQ7P0aRECRZkun1I7sUJRd9f9Mq5brz4HkVRtTGrXx7UVQR5M9COylps/bJc1kh7eohvJXISeooedn1Xx4xt39tU1SOQ0rDSG7F9t/uDj5XVWK3bq/PH4aIWcKhGKl9gwkX28OccTn71GLm5LWclPHgLCW+J/709P4tUr2ioN63bCbwJxgk7Vi73Dd/cmovb10QtF2QsD5xo7ZNTdvMSyXfdBPBxIpO6uZN/zlKfb8kvN8n8Cv+yZO7xXjAcDe6WpLsW1kZfRs0kdVqQ+1iLewXva437HwZJEbMasB7eEW58= swann@Suhwanui-MacBookPro.local"
}

output "swann_infra_bastion_dns" {
  value = aws_instance.swann_infra_bastion.public_dns
}
