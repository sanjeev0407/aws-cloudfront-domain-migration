# Architecture and design notes

## Request paths

### Old hostname

`Browser → Route 53 xyz.com → CloudFront old distribution → viewer-request CloudFront Function → HTTP 301 → https://abc.com + original path + query`

The old distribution does not need an origin because the function returns a response before origin selection.

### New hostname

`Browser → Route 53 abc.com → CloudFront new distribution → OAC-signed request → private S3 REST endpoint`

The new distribution redirects HTTP viewers to HTTPS. S3 website hosting is deliberately not enabled because website endpoints do not support OAC.

## DNS and TLS

A single ACM certificate in `us-east-1` includes the apex and `www` names for both domains. Route 53 DNS validation records are created from ACM's `domain_validation_options`. The certificate is attached to both CloudFront distributions.

The example expects existing public hosted zones. Domain registration and delegation are outside Terraform scope.

## Cache policy

The new content distribution uses a managed caching policy for static content and a low-cost sample TTL. The sample HTML object carries `Cache-Control: public,max-age=300`. The old-domain function returns a redirect with a short explicit cache lifetime while cutover is being verified.

## Operational guardrails

- S3 public access blocked.
- Bucket encryption and versioning enabled.
- OAC uses SigV4.
- Viewer protocol policy redirects HTTP to HTTPS.
- Terraform state backend must be secured separately.
- DNS cutover is intentionally an explicit operational step and must be reviewed.
