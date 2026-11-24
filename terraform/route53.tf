resource "aws_route53_record" "new_apex" {
  zone_id = var.new_hosted_zone_id
  name    = var.new_domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.new_site.domain_name
    zone_id                = aws_cloudfront_distribution.new_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "new_www" {
  zone_id = var.new_hosted_zone_id
  name    = var.new_www_domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.new_site.domain_name
    zone_id                = aws_cloudfront_distribution.new_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "old_apex" {
  zone_id = var.old_hosted_zone_id
  name    = var.old_domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.old_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.old_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "old_www" {
  zone_id = var.old_hosted_zone_id
  name    = var.old_www_domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.old_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.old_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}
