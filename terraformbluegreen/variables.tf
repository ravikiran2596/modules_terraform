variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "default region"
}

variable "vpc_id" {
  type        = string
  default     = "10.120.0.0/16"
  description = "vpc id for default use"
}



variable "my_information" {
  type = map(object({
    subnet_Name       = string
    instance_Name     = string
    instance_type     = string
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    "subnet1" = {
      subnet_Name       = "SUB1"
      instance_Name     = "BLUE"
      instance_type     = "t2.micro"
      availability_zone = "ap-northeast-1a"
      cidr_block        = "10.120.0.0/24"
    }
    "subnet2" = {
      subnet_Name       = "SUB2"
      instance_Name     = "GREEN"
      instance_type     = "t2.micro"
      availability_zone = "ap-northeast-1c"
      cidr_block        = "10.120.1.0/24"
    }
  }
}