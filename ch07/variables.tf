variable "region" {
   description = "AWS region. Changing it will lead to loss of complete stack."
   default = "ap-northeast-1"
}

variable "environment" {
   default = "dev"
}

# list variable
variable "allow_ssh_access" {
   description = "List of CIDR blocks that can access instances via SSH"
   default = ["0.0.0.0/0"]
}

# string variable
variable "vpc_cidr" {
   default = "10.0.0.0/16"
}

# map variable
variable "subnet_cidrs" {
   description = "CIDR blocks for public and private subnets"

   default = {
     "ap-northeast-1a-public" = "10.0.1.0/24"
     "ap-northeast-1a-private" = "10.0.2.0/24"
     "ap-northeast-1c-public" = "10.0.3.0/24"
     "ap-northeast-1c-private" = "10.0.4.0/24"
   }
}

variable "external_nameserver" {
   default = "8.8.8.8"
}

variable "extra_packages" {
   description = "Additional packages to install for particular module"
   default = {
     MightyTrousers = "wget bind-utils"
   }
}
