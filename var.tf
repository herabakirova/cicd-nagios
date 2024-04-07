variable region {
  type        = string
  default     = "us-east-2"
  description = "provide the region"
}

variable vpc_name {
  type        = string
  default     = "project"
  description = "provide vpc name"
}

variable cidr {
  type        = string
  default     = "10.0.0.0/16"
  description = "provide the cidr block"
}

variable subnet1_cidr {
  type        = string
  default     = "10.0.1.0/24"
  description = "provide cidr block for subnet 1"
}

variable subnet1_name {
  type        = string
  default     = "subnet1"
  description = "provide subnet 1 name"
}

variable subnet2_cidr {
  type        = string
  default     = "10.0.2.0/24"
  description = "provide cidr block for subnet 2"
}

variable subnet2_name {
  type        = string
  default     = "subnet2"
  description = "provide subnet 2 name"
}

variable subnet3_cidr {
  type        = string
  default     = "10.0.3.0/24"
  description = "provide cidr block for subnet 3"
}

variable subnet3_name {
  type        = string
  default     = "subnet3"
  description = "provide subnet 3 name"
}

variable ig_name {
  type        = string
  default     = "main"
  description = "provide internet gateway name"
}

variable rt_cidr {
  type        = string
  default     = "0.0.0.0/0"
  description = "provide route table cidr block"
}

variable rt_name {
  type        = string
  default     = "route"
  description = "provide route table name"
}

variable ec2_type {
  type        = string
  default     = "t3.2xlarge"
  description = "provide instance type"
}

variable az {
  type        = string
  default     = "us-east-2a"
  description = "provide availability zone"
}

variable ec2_name {
  type        = string
  default     = "project"
  description = "provide instance name"
}

variable userdata {
  type        = string
  default     = "/home/ec2-user/terraform-aws-project3/script.sh"
  description = "provide the path to the script"
}
