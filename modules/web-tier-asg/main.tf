# ---------------------------------------------------------------
# External ASG: web servers in the public subnets (both AZs)
# ---------------------------------------------------------------
resource "aws_launch_template" "web" {
  name_prefix            = "${var.name_prefix}-web-tier"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.web-tier-sg
  update_default_version = true
  key_name               = "aws-key"

  iam_instance_profile {
    name = var.cloudwatch
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # IMDSv2 only
  }

  user_data = base64encode(templatefile("${path.module}/web.sh", {
    dns_in-lb = var.dns_in-lb
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.name_prefix}-web", Tier = "web" }
  }
}

resource "aws_autoscaling_group" "external" {
  name                      = "${var.name_prefix}-ex-asg"
  min_size                  = var.asg_config.min
  desired_capacity          = var.asg_config.desired
  max_size                  = var.asg_config.max
  vpc_zone_identifier       = var.subnet-public
  target_group_arns         = [var.target_web]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-web"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity] # target tracking changes it
  }
}

resource "aws_autoscaling_policy" "external_cpu" {
  name                   = "${var.name_prefix}-external-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.external.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = var.asg_cpu_target

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}