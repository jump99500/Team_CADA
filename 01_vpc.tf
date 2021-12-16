provider "aws" {                     #aws 서비스를 이용
    region = "ap-northeast-2"

}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags = {
      "Name"    = "vpc"
  }
}

resource "aws_subnet" "pub_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-northeast-2a"
  #map_customer_owned_ip_on_launch = true
  tags = {
    "Name" = "pub-1"
  }
}


resource "aws_subnet" "pub_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-2c"
  #map_customer_owned_ip_on_launch = true
  tags = {
    "Name" = "pub-2"
  }
}


resource "aws_subnet" "web_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "web-1"
  }
}

resource "aws_subnet" "web_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "web-2"
  }
}


resource "aws_subnet" "was_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "was-1"
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


resource "aws_subnet" "db_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.6.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "db-1"
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


resource "aws_subnet" "ansible_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.8.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "ansible"
  }
}


resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db-subnet-group"
    subnet_ids = [aws_subnet.db_subnet_1.id , aws_subnet.db_subnet_2.id]  #여기

    tags = {
        name = "db-subnet-group"
    }
}