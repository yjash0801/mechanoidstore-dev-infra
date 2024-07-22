variable "project_name" {
    default = "mechanoidstore"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Name = "mechanoidstore"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "tags" {
    default = {
        Component = "shipping"
    }
}

variable "dns" {
    default = "mechanoidstore.online"
}

variable "iam_instance_profile" {
    default = "EC2RoleforShell"
}