terraform {
  required_version = "~>0.8.7"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.my_vpc.id}"
}

resource "aws_nat_gateway" "imported_gateway" {
   allocation_id = "eipalloc-76a44612"
   subnet_id = "${aws_subnet.private-1.id}"
   depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_default_route_table" "default_routing" {
   default_route_table_id = "${aws_vpc.my_vpc.default_route_table_id}"
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = "${aws_internet_gateway.gw.id}"
   }
}

resource "aws_subnet" "public-1" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block = "${lookup(var.subnet_cidrs, "ap-northeast-1a-public")}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public-2" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  availability_zone = "ap-northeast-1c"
  cidr_block = "${lookup(var.subnet_cidrs, "ap-northeast-1c-public")}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private-1" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block = "${lookup(var.subnet_cidrs, "ap-northeast-1a-private")}"
}

resource "aws_subnet" "private-2" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  availability_zone = "ap-northeast-1c"
  cidr_block = "${lookup(var.subnet_cidrs, "ap-northeast-1c-private")}"
}

resource "aws_security_group" "default" {
   name = "Default SG"
   description = "Allow SSH access"
   vpc_id = "${aws_vpc.my_vpc.id}"

   ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["${var.allow_ssh_access}"]
   }
}

resource "aws_key_pair" "terraform" {
  key_name = "terraform"
  public_key = "${file("/home/vagrant/.ssh/id_rsa.pub")}"
}

module "mighty_trousers" {
  source = "./modules/application"
  vpc_id = "${aws_vpc.my_vpc.id}"
  subnets = ["${aws_subnet.public-1.id}", "${aws_subnet.public-2.id}"]
  name = "MightyTrousers"
  keypair = "${aws_key_pair.terraform.key_name}"
  environment = "${var.environment}"
  extra_sgs = ["${aws_security_group.default.id}"]
  extra_packages = "${lookup(var.extra_packages, "MightyTrousers")}"
  external_nameserver = "${var.external_nameserver}"
  instance_count = 2
}

output "mighty_trousers_app_address" {
  value = "${module.mighty_trousers.app_address}"
}
