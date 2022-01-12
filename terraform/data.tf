variable "default_vpc_id" {
  default = "vpc-3163f05a" // ap-northeast-2
}

data "aws_vpc" "default" {
  id = var.default_vpc_id
}
