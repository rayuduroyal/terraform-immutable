resource "aws_subnet" "private_subnets" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.addon]
  count      = length(var.PRIVATE_SUBNETS)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.PRIVATE_SUBNETS,count.index)
  availability_zone = element(var.AZS, count.index)

  tags = {
    Name = "private_subnet-${count.index}"
  }
}

resource "aws_subnet" "public_subnets" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.addon]
  count      = length(var.PUBLIC_SUBNETS)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.PUBLIC_SUBNETS,count.index)
  availability_zone = element(var.AZS, count.index)

  tags = {
    Name = "public_subnet-${count.index}"
  }
}

resource "aws_route_table_association" "priv_assoc" {
  count          = length(aws_subnet.private_subnets.*.id)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public_subnets.*.id)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route.id
}