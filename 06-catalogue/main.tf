resource "aws_lb_target_group" "catalogue" {
  name     = "${local.name}-${var.tags.Component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
      healthy_threshold   = 2
      interval            = 10
      unhealthy_threshold = 3
      timeout             = 5
      path                = "/health"
      port                = 8080
      matcher = "200-299"
  }
}

module "catalogue" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${local.name}-${var.tags.Component}-ami"
  ami = data.aws_ami.centos.id
  instance_type          = var.t2-micro
  #key_name               = "user1"
  #monitoring             = true
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = local.private_subnet_id 

  tags = merge(

    var.common_tags,
    var.tags,
    {
        Name = "${local.name}-${var.tags.Component}-ami"
    }
  )
}

resource "null_resource" "catalogue" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.catalogue.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  
  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue dev"
    ]
  }
}

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = module.catalogue.id
  state       = "stopped"

  depends_on = [ null_resource.catalogue ]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.name}-${var.tags.Component}-${local.current_timestamp}"
  source_instance_id = module.catalogue.id

  tags = merge(

    var.common_tags,
    var.tags,
    {
        Name = "${local.name}-${var.tags.Component}"
    }
  )
}

resource "null_resource" "catalogue_terminate" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id
  }
  
  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"
    }
    depends_on = [ aws_ami_from_instance.catalogue ]
}

resource "aws_launch_template" "catalogue" {
  name = "${local.name}-${var.tags.Component}"

  image_id = aws_ami_from_instance.catalogue.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.t2-micro

  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-${var.tags.Component}"
    }
  }

}