resource "aws_acm_certificate" "domains" {
  provider          = aws.use1
  domain_name       = var.new_domain
  validation_method = "DNS"

  subject_alternative_names = [
    var.new_www_domain,
    var.old_domain,
    var.old_www_domain
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.domains.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = (
    endswith(each.key, var.old_domain) && !endswith(each.key, var.new_domain)
    ? var.old_hosted_zone_id
    : var.new_hosted_zone_id
  )

  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "domains" {
  provider                = aws.use1
  certificate_arn         = aws_acm_certificate.domains.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}
