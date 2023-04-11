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
}


resource "aws_route_table" "myroutetable" {
    
  
}