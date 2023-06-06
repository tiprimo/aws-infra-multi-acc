variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_name" {
    type = string
    }

variable "subnets_to_share" {
    type = set(string)
    default = []
  
}

variable "public_subnets" {
  type    = map(object({
    cidr_block = string
  }))
  default = {}
}

variable "private_subnets" {
  type    = map(object({
    cidr_block = string
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "ram_name" {
    type = string
}

variable "account_ids" {
  description = "List of AWS account IDs to share resources with"
  type        = list(string)
  default     = []
}

# variable "public_subnet_arns" {
#     type = map(string)
# }


# variable "private_subnet_arns" {
#     type = map(string)
# }