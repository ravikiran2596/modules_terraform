provider "aws" {
  region = "ap-northeast-1"
}

module "aws_vpc" {
  source = "./modules/aws_vpc"

  info_info = {
    RAVI_APP1_SUBNET = "192.168.0.0/24"
    RAVI_VPC_RANGE   = "192.168.0.0/16"
    region           = "ap-northeast-1"
    subnet_name      = "APP1"
    ec2_subnets      = ["APP1"]
  }
}

