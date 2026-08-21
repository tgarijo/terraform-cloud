

variable "instances" {
  description = "Number of instances to create"
  type        = list(string)
  #type        = set(string)
  #default = ["apache", "mysql", "jumpserver"]
  default = ["apache"]
}

resource "aws_instance" "public_instance" {
  //count                  = length(var.instances) // count is not recommended for resources that are created with a list or set of values, 
  //because it can cause issues with resource replacement and state management. 
  //Instead, use for_each to create multiple instances based on the values in the instances variable.

  for_each               = toset(var.instances)
  ami                    = var.ec2_specs.ami_id
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  //key_name               = data.aws_key_pair.key.key_name
  user_data              = file("./scripts/user-data.sh")

  tags = {
    Name = "${each.value}-${local.sufix}"
  }

}



resource "aws_instance" "monitoring_instance" {
  # In this case count is a condicional, if enable_monitoring is true then count = 1, then deploy one instance
  # if is false then count = 0 deploy 0 instances
  count                  = var.enable_monitoring ? 1 : 0
  ami                    = var.ec2_specs.ami_id
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  key_name               = data.aws_key_pair.key.key_name
  user_data              = file("./scripts/user-data.sh")

  tags = {
    Name = "monitoring-${local.sufix}"
  }

}



 