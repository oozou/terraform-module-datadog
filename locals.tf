locals {
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
  name                = format("%s-%s-%s", var.prefix, var.environment, var.name)
  profile_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"]
  security_group_ids  = concat(var.additional_sg_attacment_ids, var.is_create_security_group ? [aws_security_group.this[0].id] : [])

  console_rule = [{
    port                  = 22,
    protocol              = "TCP"
    health_check_protocol = "TCP"
  }]
  public_rule              = concat(var.public_rule, var.is_enabled_https_public ? local.console_rule : [])
  private_rule             = concat(var.private_rule, local.console_rule)
  default_https_allow_cidr = var.is_enabled_https_public ? ["0.0.0.0/0"] : [data.aws_vpc.this.cidr_block]
  security_group_ingress_rules = merge(var.security_group_ingress_rules)
  # region = var.datadog_region
  # secret_id = var.datadog_secret
  # s3 = var.datadog_s3
}
