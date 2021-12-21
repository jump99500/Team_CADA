#EIP 만들기
resource "aws_eip" "cd_ngw_ip" {
  vpc = true
}
# NAT게이트웨이 만들기
resource "aws_nat_gateway" "cd_ngw" {
  allocation_id = aws_eip.cd_ngw_ip.id
  subnet_id     = aws_subnet.cd_pub1.id
  tags = {
    "Name" = "cd-ngw"
  }
}

resource "aws_route_table" "cd_ngwrt" {
  vpc_id = aws_vpc.cd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.cd_ngw.id
  }
  tags = {
    "Name" = "cd-ngwrt"
  }
}

resource "aws_route_table_association" "cd_ngwass_priweb1" {
  subnet_id      = aws_subnet.cd_priweb1.id
  route_table_id = aws_route_table.cd_ngwrt.id
}

resource "aws_route_table_association" "cd_ngwass_priweb2" {
  subnet_id      = aws_subnet.cd_priweb2.id
  route_table_id = aws_route_table.cd_ngwrt.id
}

resource "aws_route_table_association" "cd_ngwass_priwas1" {
  subnet_id      = aws_subnet.cd_priwas1.id
  route_table_id = aws_route_table.cd_ngwrt.id
}

resource "aws_route_table_association" "cd_ngwass_priwas2" {
  subnet_id      = aws_subnet.cd_priwas2.id
  route_table_id = aws_route_table.cd_ngwrt.id
}

resource "aws_route_table_association" "cd_ngwass_pridb1" {
  subnet_id      = aws_subnet.cd_pridb1.id
  route_table_id = aws_route_table.cd_ngwrt.id
}

resource "aws_route_table_association" "cd_ngwass_pridb2" {
  subnet_id      = aws_subnet.cd_pridb2.id
  route_table_id = aws_route_table.cd_ngwrt.id
}
