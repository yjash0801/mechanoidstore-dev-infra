variable "vpc_cidr" {
    default = "192.168.0.0/16"
}

variable "common_tags" {
    default = {
        Project = "mechanoidstore"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "vpc_tags" {
    default = {}
}

variable "project_name" {
    default = "mechanoidstore"
}

variable "environment" {
    default = "dev"
}

variable "public_subnets_cidr" {
    default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnets_cidr" {
    default = ["192.168.11.0/24", "192.168.12.0/24"]
}

variable "database_subnets_cidr" {
    default = ["192.168.21.0/24", "192.168.22.0/24"]
}

variable "is_peering_required" {
    default = true
}