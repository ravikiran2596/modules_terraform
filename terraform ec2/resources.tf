resource "aws_vpc" "RAVI" {
  cidr_block = var.info_info.RAVI_VPC_RANGE
  tags = {
    Name = "RAVI"
  }

}

resource "aws_subnet" "APP1" {
  vpc_id            = aws_vpc.RAVI.id
  cidr_block        = var.info_info.RAVI_APP1_SUBNET
  availability_zone = "${var.info_info.region}a"
  tags = {
    Name = "APP1"
  }
}


resource "aws_internet_gateway" "Mygateway" {
  vpc_id = aws_vpc.RAVI.id
  tags = {
    Name = "Mygateway"
  }
  depends_on = [
    aws_vpc.RAVI
  ]
}


resource "aws_route_table" "Myroutetable" {
  vpc_id = aws_vpc.RAVI.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Mygateway.id
  }
  tags = {
    Name = "Myroutetable"
  }
}


data "aws_subnet" "mysubnetno" {
  filter {
    name   = "tag:Name"
    values = [var.info_info.subnet_name]
  }

  filter {
    name   = "vpc-id"
    values = [aws_vpc.RAVI.id]
  }
  depends_on = [
    aws_vpc.RAVI,
    aws_subnet.APP1
  ]
}

resource "aws_route_table_association" "table_link" {
  subnet_id      = data.aws_subnet.mysubnetno.id
  route_table_id = aws_route_table.Myroutetable.id
  depends_on = [
    aws_subnet.APP1,
    aws_internet_gateway.Mygateway
  ]
}