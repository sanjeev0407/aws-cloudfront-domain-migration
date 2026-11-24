locals {
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Environment = "portfolio"
  }

  old_names = [var.old_domain, var.old_www_domain]
  new_names = [var.new_domain, var.new_www_domain]
  all_names = distinct(concat(local.old_names, local.new_names))
}

resource "aws_cloudfront_function" "old_domain_redirect" {
  name    = "${var.project_name}-old-domain-301"
  runtime = "cloudfront-js-2.0"
  comment = "301 redirect from old hostnames to the new canonical domain; preserve path and query."
  publish = true
  code    = file("${path.module}/functions/old-domain-redirect.js")
}
