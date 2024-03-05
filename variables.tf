variable "instance-type" {
  default = "t2.small"
}

#autosacling config
variable "max-size" {
  default = "4"
}
variable "min-size" {
  default = "2"
}
variable "desired-size" {
  default = "2"
}

#get the ami of amazon linux 2023 using data source

variable "db_name" {
  default = "emp"
}
variable "db_instance_class" {
  default = "db.t3.micro"
}
variable "db_username" {
  default = "root"
}
variable "db_password" {
  default = "dhirajD12"
}
