output "dns_name" {
  value = {
    internal = aws_lb.internal.dns_name
    external = aws_lb.external.dns_name
  }
}
output "app" {
  value = aws_lb_target_group.app.arn
}
output "web" {
  value = aws_lb_target_group.web.arn
}
