variable "virginia_cidr" {
  //default = "10.10.0.0/16"
  description = "CIDR block for the Virginia VPC"
  type        = string
  sensitive   = false

}


# variable "public_subnet" {π
#   description = "CIDR block for the public subnet"
#   type        = string
# }


# variable "private_subnet" {
#   description = "CIDR block for the private subnet"
#   type        = string
# }


variable "subnets" {
  description = "Lista de subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR  for the security group ingress"
  type        = string
}

variable "ec2_specs" {
  description = "Especificaciones de la instancia EC2"
  type = object({
    instance_type = string
    ami_id        = string
  })
}

variable "enable_monitoring" {
  description = "Hability server monitoring server"
  type        = bool
}

variable "ingress_ports_list" {
  description = "List of ingress ports to allow"
  type        = list(number) 
}

variable "access_key" {}
variable "secret_key" {}