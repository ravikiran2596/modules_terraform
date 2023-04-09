
variable "info_info" {
  type = object({
    region           = string,
    RAVI_VPC_RANGE   = string,
    RAVI_APP1_SUBNET = string,
    subnet_name      = string
    ec2_subnets      = list(string)
    rollout_version  = string
  })
  default = {
    RAVI_APP1_SUBNET = "192.168.0.0/24"
    RAVI_VPC_RANGE   = "192.168.0.0/16"
    region           = "ap-northeast-1"
    subnet_name      = "APP1"
    ec2_subnets      = ["APP1"]
    rollout_version  = "0.0.0.0"
  }
}