terraform {
  backend "s3" {
    bucket = "suhwan.dev-terraform-backend"
    key    = "swann-infra"
    region = "ap-northeast-2"
  }
}

resource "aws_s3_bucket" "terraform_backend" {
  bucket = "suhwan.dev-terraform-backend"
}
