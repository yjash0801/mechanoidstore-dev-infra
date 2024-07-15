variable "project_name" {
    default = "mechanoidstore"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "mechanoidstore"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "sg_tags" {
    default = {}
}

# variable "mongodb_sg_ingress_rules" {
#     default = [
#     {
#     description = "Allow port 80"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     },
#     {
#         description = "Allow port 443"
#         from_port        = 443
#         to_port          = 443
#         protocol         = "tcp"
#         cidr_blocks      = ["0.0.0.0/0"]

#     }
    # {
    #     description = "Allow port 22"
    #     from_port        = 22
    #     to_port          = 22
    #     protocol         = "tcp"
    #     cidr_blocks      = ["0.0.0.0/0"]
    # },

    # {
    #     description = "Allow port 3306"
    #     from_port        = 3306
    #     to_port          = 3306
    #     protocol         = "tcp"
    #     cidr_blocks      = ["0.0.0.0/0"]
    # }
#     ]
# }