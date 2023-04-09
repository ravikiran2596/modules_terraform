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
  ami                         = local.ami_id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.WEB12.id
  vpc_security_group_ids      = [aws_security_group.Sgroup.id]
  key_name                    = "DELL8.rsa"
  tags = {
    Name = "ravi123"
  }

  depends_on = [
    aws_security_group.Sgroup
  ]

}

