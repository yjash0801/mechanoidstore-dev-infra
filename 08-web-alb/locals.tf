locals {
    name = "${var.project_name}-${var.environment}"
    # database_subnet_id = element(split(",", data.aws_ssm_parameter.database_subnet_ids.value),0)
    # private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
}