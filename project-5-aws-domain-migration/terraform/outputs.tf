output "site_bucket_name" {
  description = "Private S3 bucket for the new domain."
  value       = aws_s3_bucket.site.id
}

output "new_distribution_id" {
  description = "CloudFront distribution serving the new domain."
  value       = aws_cloudfront_distribution.new_site.id
}

output "new_distribution_domain_name" {
  value = aws_cloudfront_distribution.new_site.domain_name
}

output "old_redirect_distribution_id" {
  description = "CloudFront distribution returning 301 redirects for old hostnames."
  value       = aws_cloudfront_distribution.old_redirect.id
}

output "old_redirect_distribution_domain_name" {
  value = aws_cloudfront_distribution.old_redirect.domain_name
}

output "certificate_arn_us_east_1" {
  value = aws_acm_certificate_validation.domains.certificate_arn
}
