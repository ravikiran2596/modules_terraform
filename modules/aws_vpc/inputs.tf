
variable "info_info" {
  type = object({
    region           = string,
    RAVI_VPC_RANGE   = string,
    RAVI_APP1_SUBNET = string,
    subnet_name      = string
    ec2_subnets      = list(string)

  })
  default = {
    RAVI_APP1_SUBNET = "192.168.0.0/24"
    RAVI_VPC_RANGE   = "192.168.0.0/16"
    region           = "ap-northeast-1"
    subnet_name      = "APP1"
    ec2_subnets      = ["APP1"]
  }
}

variable "aws_ec2" {
  type = map(object({
    Name = string
    region = string
  }))
  default = {
    "RED" = {
      Name = "RED1"
      region = "ap-northeast-1"
    }
    "GREEN" = {
      Name = "GREEN1"
      region = "ap-northeast-1"
    }
  }
}