resource "aws_vpc" "RAVIVPC" {
  cidr_block = var.vpc_id
  tags = {
    Name = "RAVIVPC"
  }
}

resource "aws_subnet" "RAVISUBNET" {
  for_each          = var.my_subnet
  availability_zone = each.value.availability_zone
  vpc_id            = aws_vpc.RAVIVPC.id
  cidr_block        = each.value.cidr_block
  tags = {
    Name = each.value.Name
  }
  depends_on = [
    aws_vpc.RAVIVPC
  ]
}

resource "aws_internet_gateway" "myinternet" {
  vpc_id = aws_vpc.RAVIVPC.id
  tags = {
    Name = "myinternet"
  }
  depends_on = [
    aws_vpc.RAVIVPC
  ]
}


resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.RAVIVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myinternet.id
  }
  tags = {
    Name = "myroutetable"
  }
  depends_on = [
    aws_vpc.RAVIVPC,
    aws_internet_gateway.myinternet
  ]
}

resource "aws_route_table_association" "tableassociate" {
  for_each       = var.my_subnet
  subnet_id      = aws_subnet.RAVISUBNET[each.key].id
  route_table_id = aws_route_table.myroutetable.id

  depends_on = [
    aws_route_table.myroutetable,
    aws_subnet.RAVISUBNET
  ]
}

data "aws_ami_ids" "ubuntu_2204" {
  owners = ["099720109477"]
  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-02-08"]
  }
  filter {
    name   = "is-public"
    values = ["true"]
  }

}

resource "aws_security_group" "Mysecurity" {
  name        = "Mysecurity"
  description = "all rules"
  vpc_id      = aws_vpc.RAVIVPC.id

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
  tags = {
    Name = "Mysecurity"
  }
  depends_on = [
    aws_subnet.RAVISUBNET
  ]
}



resource "aws_instance" "RAVIINSTANCE" {
  for_each                    = var.my_subnet
  associate_public_ip_address = true
  ami                         = local.ami_id
  subnet_id                   = aws_subnet.RAVISUBNET[each.key].id
  availability_zone           = each.value.availability_zone
  instance_type               = each.value.instance_type
  key_name                    = "DELL8.rsa"
  vpc_security_group_ids      = [aws_security_group.Mysecurity.id]

  tags = {
    Name = each.value.Name
  }
  depends_on = [
    aws_subnet.RAVISUBNET,
    aws_security_group.Mysecurity
  ]
}