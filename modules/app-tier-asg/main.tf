# ---------------------------------------------------------------
# Internal ASG: application servers in the private app subnets
# ---------------------------------------------------------------
resource "aws_launch_template" "app" {
  name_prefix            = "${var.name_prefix}-app-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.app-sg
  update_default_version = true
  # key_name               = "aws-key"

  iam_instance_profile {
    name = var.cloudwatch
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = base64encode(templatefile("${path.module}/app.sh", {
    db_password = var.db_password,
    db_username = var.db_username,
    db_name     = var.db_name,
    endpoint    = var.endpoint
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.name_prefix}-app", Tier = "app" }
  }
}

resource "aws_autoscaling_group" "internal" {
  name                      = "${var.name_prefix}-in-asg"
  min_size                  = var.asg_config.min
  desired_capacity          = var.asg_config.desired
  max_size                  = var.asg_config.max
  vpc_zone_identifier       = var.subnet-private-app
  target_group_arns         = [var.target_app]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-app"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  # App servers install packages through the NAT gateways
  #depends_on = [aws_nat_gateway.main, aws_route_table_association.private_app]
}

resource "aws_autoscaling_policy" "internal_cpu" {
  name                   = "${var.name_prefix}-internal-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.internal.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = var.asg_cpu_target

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}
