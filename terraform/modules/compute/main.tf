

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  tags = { Name = "${var.project}-alb" }
}

resource "aws_lb_target_group" "backend" {
  name     = "${var.project}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

# IAM Role for EC2 (CloudWatch access)
resource "aws_iam_role" "ec2" {
  name = "${var.project}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project}-ec2-profile"
  role = aws_iam_role.ec2.name
}

# Launch Template
resource "aws_launch_template" "backend" {
  name_prefix   = "${var.project}-backend-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile { name = aws_iam_instance_profile.ec2.name }
  vpc_security_group_ids = [var.ec2_sg_id]
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    ecr_registry = var.ecr_registry
    image_tag    = var.image_tag
    mongo_uri    = var.mongo_uri
    redis_url    = var.redis_url
  }))
  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${var.project}-backend" }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "backend" {
  name                = "${var.project}-asg"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [aws_lb_target_group.backend.arn]
  health_check_type   = "ELB"
  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.project}-backend"
    propagate_at_launch = true
  }
}

# Scaling policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}
