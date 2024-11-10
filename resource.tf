resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "test-vpc"
  }
}

resource "aws_subnet" "my-pub-subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    name = "test-subnet"
  }
}

resource "aws_internet_gateway" "my-IGW" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    name = "test-IGW"
  }
}

resource "aws_route_table" "my-RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-IGW.id
  }
}

resource "aws_route_table_association" "my-RT-ASSO" {
  subnet_id      = aws_subnet.my-pub-subnet.id
  route_table_id = aws_route_table.my-RT.id
}

resource "aws_security_group" "my-SG" {
  name   = "test-SG"
  vpc_id = aws_vpc.myvpc.id
  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-ec2" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key-pair
  security_groups = [aws_security_group.my-SG.id]
  subnet_id       = aws_subnet.my-pub-subnet.id
  tags = {
    name = "sns-cloud-watch-EC2"
  }
}

resource "aws_sns_topic" "my-sns" {
  name = "cpu-utilization-alert"
}

resource "aws_sns_topic_subscription" "my-sns-suscribtion" {
  topic_arn = aws_sns_topic.my-sns.arn
  protocol  = "email"
  endpoint  = "your-email@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 10
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU utilization exceeds 70%"
  dimensions = {
    InstanceId = aws_instance.my-ec2.id
  }

  alarm_actions = [aws_sns_topic.my-sns.arn]
}

resource "aws_cloudwatch_dashboard" "cpu_dashboard" {
  dashboard_name = "EC2_CPU_Utilization_Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 0,
        "y" : 0,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "metrics" : [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.my-ec2.id ]
          ],
          "title" : "EC2 Instance CPU Utilization",
          "view" : "timeSeries",
          "stacked" : false,
          "region" : "ap-northeast-1",
          "stat" : "Average",
          "period" : 10,  # 5-minute intervals
          "start" : "-PT1H"  # Show data from the last hour
        }
      }
    ]
  })
}

