resource "aws_vpc" "cd_vpc" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "cd-vpc"
  }
}

resource "aws_subnet" "cd_pub1" {
  vpc_id            = aws_vpc.cd_vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "cd-pub1"
  }
}

resource "aws_subnet" "cd_pub2" {
  vpc_id            = aws_vpc.cd_vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "cd-pub2"
  }
}

resource "aws_subnet" "cd_priweb1" {
  vpc_id            = aws_vpc.cd_vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "cd-priweb1"
  }
}

resource "aws_subnet" "cd_priweb2" {
  vpc_id            = aws_vpc.cd_vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "cd-priweb2"
  }
}

resource "aws_subnet" "cd_priwas1" {
  vpc_id            = aws_vpc.cd_vpc.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "cd-priwas1"
  }
}

resource "aws_subnet" "cd_priwas2" {
  vpc_id            = aws_vpc.cd_vpc.id
  cidr_block        = "192.168.5.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "cd-priwas2"
  }
}

resource "aws_subnet" "cd_pridb1" {
  vpc_id            = aws_vpc.cd_vpc.id
  cidr_block        = "192.168.6.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "cd-pridb1"
  }
}

resource "aws_subnet" "cd_pridb2" {
  vpc_id            = aws_vpc.cd_vpc.id
  cidr_block        = "192.168.7.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "cd-pridb2"
  }
}