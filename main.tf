provider "aws" {
    shared_config_files = ["C:/Users/Jenny/.aws/config"]
    shared_credentials_files = ["C:/Users/Jenny/.aws/credentials"]
}

resource "aws_vpc" "fis-vpc" {
    cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "public_subnet" {
    cidr_block = "10.1.1.0/24"
    vpc_id = aws_vpc.fis-vpc.id
}

resource "aws_subnet" "private_subnet" {
    cidr_block = "10.1.2.0/24"
    vpc_id = aws_vpc.fis-vpc.id
}

resource "aws_internet_gateway" "fis_public_internet_gateway" {
    vpc_id = aws_vpc.fis-vpc.id
}

resource "aws_route_table" "fis_public_subnet_route_table" {
    vpc_id = aws_vpc.fis-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.fis_public_internet_gateway.id    
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.fis_public_internet_gateway.id
    }
}

resource "aws_route_table_association" "fis_public_association" {
    route_table_id = aws_route_table.fis_public_subnet_route_table.id
    subnet_id = aws_subnet.public_subnet.id 
}