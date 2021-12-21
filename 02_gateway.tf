resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${format("%s-igw", var.name)}"
  }
}

resource "aws_eip" "eip_nat" {
  vpc = true
}

  
resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.eip_nat.id
    subnet_id = aws_subnet.public[0].id
    tags = {
        "Name" = "cd-nat"
    }
}


/*
resource "aws_nat_gateway" "ngw_1" {
  allocation_id = aws_eip.eip_nat_1.id
  subnet_id     = aws_subnet.pub_1.id
  tags = {
    "Name" = "cd-ngw-1"
  }
}

resource "aws_eip" "eip_nat_2" {
  vpc = true
}

resource "aws_nat_gateway" "ngw_2" {
  allocation_id = aws_eip.eip_nat_2.id
  subnet_id     = aws_subnet.pub_2.id
  tags = {
    "Name" = "cd-ngw-2"
  }
}
*/