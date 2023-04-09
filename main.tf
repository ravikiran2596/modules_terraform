provider "aws" {
  region = "ap-northeast-1"
}

module "aws_instance" {
  source = "./modules/aws_vpc"
}


