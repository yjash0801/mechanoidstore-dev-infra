data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "app_alb_sg_id" {
    name = "/${var.project_name}/${var.environment}/app_alb_id"
}

data "aws_vpc" "default"{
  default = true
}

data "aws_subnet" "default_subnet" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1a"
}