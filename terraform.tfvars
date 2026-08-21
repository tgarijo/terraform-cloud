/* 
Este archivo se definen los valores de las variables que se han definido en el archivo
variables.tf, el nombre de este archivo debe ser terraform.tfvars y se encuentra en la 
misma carpeta que el archivo variables.tf 

Con este nombre no se puede saber la funcion de las variables, por lo que es recomendable 
cambiar el nombre del archivo a algo mas descriptivo, por ejemplo: cidr.auto.tfvars
el auto es obligatorio para que terraform lo reconozca como un archivo de variables y lo cargue automaticamente
formas de archivo :

terraforms.tfvars, terraform.tfvars.json, *.auto.tfvars, *.auto.tfvars.json

si quiseras cargar un archivo de variables con otro nombre, puedes usar el comando -var-file=nombre_archivo.tfvars 
pero no se suele trabajar de este modo
*/

/*
    los patrones de preferencia de las vars son los siguientes: 1 = menor prioridad, 4 = mayor prioridad
    1. Variables de entorno ejemplo: export TF_VAR_virginia_cidr=10.50.0.0/16
    2. Variables en archivo terraform.tfvars o terraform.tfvars.json
    3. Variables en archivo *.auto.tfvars o *.auto.tfvars.json
    4. Variables en linea de comando ejemplo: terraform apply -var="virginia_cidr=10.60.0.0/16"

*/

virginia_cidr = "10.10.0.0/16"

# public_subnet  = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"

subnets = [
  "10.10.0.0/24",
  "10.10.1.0/24"
]

tags = {
  "environment" = "dev"
  "owner"       = "tgarijo@clickonline.es"
  "project" ="click-solution"
  "region" = "virginia"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  instance_type = "t2.micro"
  ami_id        = "ami-0bdc7d025135d7b49"
}

enable_monitoring = false

ingress_ports_list = [22, 80, 443]