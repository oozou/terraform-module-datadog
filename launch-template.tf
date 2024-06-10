# Launch Configuration Template
module "launch_template" {
  source      = "oozou/launch-template/aws"
  version     = "1.0.3"
  prefix      = var.prefix
  environment = var.environment
  name        = "datadog-inst"
  user_data = base64encode(templatefile("${var.user_data}",{}))
  # user_data = base64encode(templatefile("${path.module}/template/user_data.sh",{
  #   region = var.datadog_region,
  #   s3 = var.datadog_s3,
  #   secret-id = var.datadog_secret,
  # }))
  iam_instance_profile   = { arn : aws_iam_instance_profile.this.arn }
  ami_id                 = var.ami == "" ? data.aws_ami.amazon_linux.id : var.ami
  key_name               = var.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = local.security_group_ids
  enable_monitoring      = var.enable_ec2_monitoring
  tags                   = local.tags
}
