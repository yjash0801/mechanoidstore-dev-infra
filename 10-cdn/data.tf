data "aws_ssm_parameter" "web_alb_dsn_name" {
    name = "/${var.project_name}/${var.environment}/web_alb_dsn_name"
}

data "aws_ssm_parameter" "acm_certificate_arn" {
    name = "/${var.project_name}/${var.environment}/acm_arn"
}