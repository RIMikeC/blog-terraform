terraform {
  backend "s3" {
    bucket  = "test-ri-audit"
    key     = "test/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = false
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {}

module "blog" {
  aws_region  = "${data.aws_region.current.name}"
  environment = "dev"
  subnet_list = ["subnet-c0dc22a6"]

  tags = {
    owner = "mikec"
  }

  source = "../../../modules/blog"
}
