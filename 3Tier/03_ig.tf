resource "aws_internet_gateway" "cd_ig" {
  vpc_id = aws_vpc.cd_vpc.id

  tags = {
    "Name" = "cd-ig"
  }
}

resource "aws_route_table" "cd_rt" {
  vpc_id = aws_vpc.cd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cd_ig.id
  }
  tags = {
    "Name" = "cd-rt"
  }
}

resource "aws_route_table_association" "cd_igas_pub1" {
  subnet_id      = aws_subnet.cd_pub1.id
  route_table_id = aws_route_table.cd_rt.id
}

resource "aws_route_table_association" "cd_igas_pub2" {
  subnet_id      = aws_subnet.cd_pub2.id
  route_table_id = aws_route_table.cd_rt.id
}
