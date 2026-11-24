[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$PreviousWorkingHostname
)

Write-Warning "This script is a controlled rollback checklist; it does not change DNS or CloudFront automatically."
Write-Host "1. Confirm the previous service is healthy: https://$PreviousWorkingHostname"
Write-Host "2. Inspect current CloudFront Function and DNS records."
Write-Host "3. Update the old-domain function destination to the approved recovery hostname, or restore the captured prior DNS record."
Write-Host "4. Review terraform plan and obtain change approval before applying."
Write-Host "5. Validate Location headers with curl.exe and monitor CloudFront 4xx/5xx, DNS, and application health."
Write-Host "6. Remember: clients may cache 301 redirects; test from a clean client and communicate cache behavior."
