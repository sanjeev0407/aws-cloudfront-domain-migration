variable "aws_region" {
  description = "Region for the S3 origin bucket."
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "Optional local AWS CLI profile. Leave empty to use the default credential chain."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Short project identifier used in resource names."
  type        = string
  default     = "domain-migration"
}

variable "old_domain" {
  description = "Old apex domain, for example xyz.com."
  type        = string
}

variable "old_www_domain" {
  description = "Old www hostname, for example www.xyz.com."
  type        = string
}

variable "new_domain" {
  description = "New apex domain, for example abc.com."
  type        = string
}

variable "new_www_domain" {
  description = "New www hostname, for example www.abc.com."
  type        = string
}

variable "old_hosted_zone_id" {
  description = "Existing public Route 53 hosted zone ID for the old domain."
  type        = string
}

variable "new_hosted_zone_id" {
  description = "Existing public Route 53 hosted zone ID for the new domain."
  type        = string
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "Use PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}
