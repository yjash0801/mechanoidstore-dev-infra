resource "aws_ssm_parameter" "acm_arn" {
    name = "/${var.project_name}/${var.environment}/acm_arn"
    type = "String"
    value = aws_acm_certificate.mechanoidstore.arn
}