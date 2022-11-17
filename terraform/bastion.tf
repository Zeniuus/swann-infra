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

# resource "aws_instance" "swann_infra_bastion" {
#   ami           = "ami-0b827f3319f7447c6" // ap-northeast-2
#   instance_type = "t2.micro"

#   iam_instance_profile = aws_iam_instance_profile.swann_infra_bastion.id

#   key_name = "swann"

#   vpc_security_group_ids = [aws_security_group.swann_infra_bastion.id]
# }

resource "aws_security_group" "swann_infra_bastion" {
  name        = "swann-infra-bastion"
  description = "swann infra bastion instance sg"
  vpc_id      = data.aws_vpc.default.id
}

#resource "aws_security_group_rule" "bastion_to_main_db" {
#  description       = "Allow bastion instance connection"
#  security_group_id = aws_security_group.main_db.id
#
#  type                     = "ingress"
#  from_port                = 3306
#  to_port                  = 3306
#  protocol                 = "tcp"
#  source_security_group_id = aws_security_group.swann_infra_bastion.id
#}

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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAbqmVufuZEdLVI4fBKpt0Ajf4LHVFCvg7p1KkwE0Px+XiWqHp3SvPfXhX0MVtvF+sVcqDfPGx062NOHqiN+59OWsVL6mJnSNDxN2sFIyN7bqU2eiNBBoKaa86WlnWKbACl1Wv/LVxWp/16G72MPrWYx593Hg6RvyzrwwQME6wqyQ2Nf2oQjlm8U8yPvQEOK1QFbdCpgqLCg8dFSUlDeLQewPHnrZvHTi5zA4EcdtJqoGSnqa/I7V3qfsh4/E5DPcJL2uioCYCfTgFJWCX+4DeMhYlOtYEUUV6hncfBSLlzxLdp0fx/h0YNXGzKIbloq9WWN5BmXjryade2hTnQ07NGB7IFUu2+hOGQu0pomB6q2pmYT9sH6o98jtv9ejRBFMjOB3qTUROZvPrnVheXiPgZ47OzW2U805fsmEs0clSOl4YsYZJcilHyw5+yhN59QADQxxWFpVLNbQgLa/JOYhrymURiQ0zmRSmC4MM/amcPWjNbHBXYGQuQPSsD0JQMS0= suhwan@ip-172-16-12-170.ap-northeast-2.compute.internal"
}

# output "swann_infra_bastion_dns" {
#   value = aws_instance.swann_infra_bastion.public_dns
# }
