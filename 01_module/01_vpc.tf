provider "aws" { #aws 서비스를 이용
  region = "ap-northeast-2"

}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr.vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    "Name" = "var.name"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.cidr.pub)
  cidr_block        = var.cidr.pub[count.index]
  availability_zone = "${var.region.region}${var.region.az[count.index]}"
  #map_customer_owned_ip_on_launch = true
  tags = {
    "Name" = "${format("pub-%s", var.region.az[count.index])}"  #ask
  }
}


resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = "${length(var.cidr.web)}"
  cidr_block        = "${var.cidr.web[count.index]}"
  availability_zone = "${var.region.region}${var.region.az[count.index]}"
  tags = {
    "Name" = "${format("web-%s", var.region.az[count.index])}"
  }
}



resource "aws_subnet" "was_subnet" { 
    vpc_id = aws_vpc.vpc.id
    count = "${length(var.cidr.was)}"
    cidr_block = "${var.cidr.was[count.index]}"
    availability_zone = "${var.region.region}${var.region.az[count.index]}"

    tags = {
        Name = "${format("was-%s", var.region.az[count.index])}" 
    }
}


resource "aws_subnet" "db_subnet" {
    vpc_id = aws_vpc.vpc.id
    count = "${length(var.cidr.db)}"
    cidr_block = "${var.cidr.db[count.index]}"
    availability_zone = "${var.region.region}${var.region.az[count.index]}"

    tags = {
        Name = "${format("db-%s", var.region.az[count.index])}" 
    }
}

resource "aws_db_subnet_group" "db_subnet_group" {
    name = "${format("%s-db-sg", var.name)}"
    subnet_ids = "${aws_subnet.db_subnet.*.id}"

    tags = {
        name = "${format("%s-db-sg", var.name)}"
    }
}




/*
resource "aws_subnet" "pub_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-2c"
  #map_customer_owned_ip_on_launch = true
  tags = {
    "Name" = "pub-2"
  }
}
*/


/*
resource "aws_subnet" "web_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "web-2"
  }
}




resource "aws_subnet" "was_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.5.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "was-2"
  }
}




resource "aws_subnet" "db_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.7.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "db-2"
  }
}
*/
/*
resource "aws_subnet" "ansible_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.8.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "ansible"
  }
}
*/

