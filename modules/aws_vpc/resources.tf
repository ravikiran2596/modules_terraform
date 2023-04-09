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

resource "aws_security_group" "Sgroup" {
  name        = "Sgroup"
  description = "all rules"
  vpc_id      = aws_vpc.RAVI.id

  ingress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    cidr_blocks = [local.anywhere]
    protocol    = local.tcp
  }

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    cidr_blocks = [local.anywhere]
    protocol    = local.tcp
  }

  egress {
    from_port   = local.http_port
    to_port     = local.http_port
    cidr_blocks = [local.anywhere]
    protocol    = local.tcp
  }

  egress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    cidr_blocks = [local.anywhere]
    protocol    = local.tcp
  }

  tags = {
    Name = "Sgroup"
  }
  depends_on = [
    aws_subnet.APP1
  ]
}


data "aws_ami_ids" "ubuntu_2204" {
  owners = ["099720109477"]

  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-03-25"]
  }

  filter {
    name   = "is-public"
    values = ["true"]
  }
}

data "aws_subnet" "WEB12" {
  filter {
    name   = "tag:Name"
    values = var.info_info.ec2_subnets
  }
  depends_on = [
    aws_subnet.APP1
  ]
}

resource "aws_instance" "ravi123" {
  for_each = var.aws_ec2
  ami                         = local.ami_id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.WEB12.id
  vpc_security_group_ids      = [aws_security_group.Sgroup.id]
  key_name                    = "DELL8.rsa"
  tags = {
    Name = "${each.value.Name}"
  }
  depends_on = [
    aws_security_group.Sgroup
  ]

}

