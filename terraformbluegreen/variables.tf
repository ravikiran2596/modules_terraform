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

variable "my_subnet" {
  type = map(object({
    Name              = string
    instance_type     = string
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    "subnet1" = {
      Name              = "BLUE"
      availability_zone = "ap-northeast-1a"
      instance_type     = "t2.micro"
      cidr_block        = "10.120.0.0/24"
    }
    "subnet2" = {
      Name              = "GREEN"
      availability_zone = "ap-northeast-1c"
      instance_type     = "t2.micro"
      cidr_block        = "10.120.1.0/24"
    }
  }
}
