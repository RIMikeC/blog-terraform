#----------------------------------------------------------
# This module creates a VPC, subnets and routing
# The subnets are spread over 3 AZs, as per best practice.
#----------------------------------------------------------

resource "aws_vpc" "default" {
  cidr_block                       = "${var.vpc_cidr}"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  enable_classiclink               = false
  assign_generated_ipv6_cidr_block = false

  tags {
    Name = "${var.vpc_name}"
  }
}

# Fetch the names of the availability zones
data "aws_availability_zones" "current" {}

## Create subnet resources
resource "aws_subnet" "subs" {
  count                           = "${length(var.subnet_names)}"
  availability_zone               = "${data.aws_availability_zones.current.names[count.index % 3]}"
  vpc_id                          = "${aws_vpc.default.id}"
  cidr_block                      = "${var.subnet_cidrs[count.index]}"
  map_public_ip_on_launch         = true
#  map_public_ip_on_launch         = "${format("%.3s",var.subnet_names[count.index]) == "pub" ? true : false}"
  assign_ipv6_address_on_creation = false

  tags {
    Name = "${var.subnet_names[count.index]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "a" {
  count          = "${length(var.subnet_names)}"
  subnet_id      = "${element(aws_subnet.subs.*.id, count.index)}"
  route_table_id = "${aws_route_table.r.id}"
}
