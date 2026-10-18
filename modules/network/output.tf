output "network" {
  value = {
    vpc_id      = aws_vpc.main.id
    public      = aws_subnet.public[*].id
    private_app = aws_subnet.private_app[*].id
    private_db  = aws_subnet.private_db[*].id
    db-tier     = aws_security_group.db-tier.id
    web-tier    = aws_security_group.web-tier.id
    app-tier    = aws_security_group.app-tier.id
    ex-lb       = aws_security_group.ex-lb.id
    in-lb       = aws_security_group.in-lb.id

  }
}