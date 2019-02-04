terraform {
  backend "s3" {
    bucket  = "nomoreservers"
    key     = "state/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = false
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_region" "current" {}

module "blog" {
  vpc_name     = "pub"
  vpc_cidr     = "10.0.0.0/26"
  subnet_names = ["pub_a", "pub_b", "pub_c"]
  subnet_cidrs = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"]
  aws_region   = "${data.aws_region.current.name}"
  environment  = "dev"

  tags = {
    owner = "mikec"
  }

  source = "../../../modules/blog"
}
