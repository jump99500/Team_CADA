resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${format("%s-igw", var.name)}"
  }
}

resource "aws_eip" "eip_nat" {
  count = "${length(var.region.az)}"
  vpc = true
}


resource "aws_nat_gateway" "nat_gateway" {
    count ="${length(var.region.az)}"
    allocation_id = "${aws_eip.eip_nat.*.id[count.index]}"
    subnet_id = "${aws_subnet.public.*.id[count.index]}"

    tags = {
        Name = "${format("%s-nat", var.name)}"
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