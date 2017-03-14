variable "vpc_id" {}
variable "subnets" { type = "list" }
variable "name" {}
variable "keypair" {}

variable "availability_zones" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "environment" {
  default = "dev"   # The type is the string variable
}

variable "instance_type" {
  type = "map"

  default = {
    dev = "t2.micro"
    test = "t2.medium"
    prod = "t2.large"
   }
}

variable "extra_sgs" { default = [] }
variable "extra_packages" {}
variable "external_nameserver" {}
variable "instance_count" {}
