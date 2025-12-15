variable "aws_region" {
  type = string
}
variable "profile" {
  type = string
}
variable "common_tags" {
    type = map(string)
    description = "Tags comunes aplicadas a los recursos"
}
variable "client" {
  type = string
}
variable "environment" {
  type = string
}
variable "project" {
  type = string  
}
variable "functionality" {
  type = string  
}
variable "application" {
  type = string  
}

