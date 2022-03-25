#Scale up scale down policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale up policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "40"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  #  alarm_actions = [aws_autoscaling_policy.scale_up.arn, aws_sns_topic.web-cpu-alarm.arn]
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale down policy"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}
resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description = "Monitors CPU utilization for Terramino ASG"
  #  alarm_actions       = [aws_autoscaling_policy.scale_down.arn, aws_sns_topic.web-cpu-alarm.arn]
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}