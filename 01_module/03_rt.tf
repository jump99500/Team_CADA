resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id  #여기
  }
  tags = {
    "Name" = "${format("%s-pubrt", var.name)}"
  }
}

resource "aws_route_table_association" "pub_ass" {
  count = "${length(var.cidr.pub)}"
  subnet_id      = "${aws_subnet.public[count.index].id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource"aws_route_table" "web_route" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.nat_gateway[(count.index)%2].id}"
    }

    tags = {
        Name = "${format("%s-webrt", var.name)}"
    }
}

resource "aws_route_table_association" "web_ass" {
    count = "${length(var.cidr.web)}"
    subnet_id = "${aws_subnet.web_subnet[count.index].id}"
    route_table_id = "${aws_route_table.web_route.id}"
}


resource"aws_route_table" "was_route" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.nat_gateway[(count.index)%2].id}"
    }

    tags = {
        Name = "${format("%s-wasrt", var.name)}"
    }
}

resource "aws_route_table_association" "was_ass" {
    count = "${length(var.cidr.was)}"
    subnet_id = "${aws_subnet.was_subnet[count.index].id}"
    route_table_id = "${aws_route_table.was_route.id}"
}





###############################################################################
/*
resource "aws_route_table_association" "rtas_public_2" {
  subnet_id      = aws_subnet.pub_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw_1.id  #여기
  }
  tags = {
    "Name" = "cd-webrt"
  }
}


resource "aws_route_table_association" "rtas_web_2" {
  subnet_id      = aws_subnet.web_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}




resource "aws_route_table_association" "rtas_was_2" {
  subnet_id      = aws_subnet.was_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}


###################################################3

#resource "aws_route_table" "web_rt_2" {
#  vpc_id = aws_vpc.vpc.id

#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_nat_gateway.nat_gateway_2.id  #여기
#  }
#  tags = {
#    "Name" = "cd-webrt-2"
#  }
#}

/*
resource "aws_route_table" "was_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_1.id  #여기
  }
  tags = {
    "Name" = "cd-wasrt"
  }
}

#resource "aws_route_table" "was_rt_2" {
#  vpc_id = aws_vpc.vpc.id

#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_nat_gateway.nat_gateway_2.id  #여기
#  }
#  tags = {
#    "Name" = "cd-wasrt-2"
#  }
#}


resource "aws_route_table" "ansible_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_1.id  
  }
  tags = {
    "Name" = "cd-ansiblert"
  }
}


resource "aws_route_table_association" "public_ass_1" {
    subnet_id = aws_subnet.pub_1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_ass_2" {
    subnet_id = aws_subnet.pub_2.id
    route_table_id = aws_route_table.public_rt.id             
}

resource "aws_route_table_association" "web_ass_1" {
    subnet_id = aws_subnet.web_subnet_1.id
    route_table_id = aws_route_table.web_rt.id             
}



resource "aws_route_table_association" "web_ass_2" {
    subnet_id = aws_subnet.web_subnet_2.id
    route_table_id = aws_route_table.web_rt.id             
}


resource "aws_route_table_association" "ansible_ass" {
    subnet_id = aws_subnet.ansible_subnet.id
    route_table_id = aws_route_table.ansible_rt.id             
}

*/