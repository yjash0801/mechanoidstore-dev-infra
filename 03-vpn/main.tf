module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${local.name}-vpn"
  ami = data.aws_ami.centos.id
  instance_type          = var.t2-micro
  #key_name               = "user1"
  #monitoring             = true
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = data.aws_subnet.default_subnet.id
  user_data = file("openvpn.sh")
  tags = merge(

    var.common_tags,
    {
        Component = "openvpn"
    },
    {
        Name = "${local.name}-openvpn"
    }
  )
}