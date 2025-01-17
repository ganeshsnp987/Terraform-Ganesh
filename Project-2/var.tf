variable "AWS_REGION" {    
    default = "ap-south-1"
}
variable "AWS_AMI" {    
    default = "ami-0fd05997b4dff7aac"
}
# variable "akey" {
#     default = "***********************************************"
# }
# variable "skey" {
#     default = "***********************************************"
# }
# variable "pkey" {
#     # default = "linux-server"
# }
variable "rpass" {
    default = "111"
}

variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

