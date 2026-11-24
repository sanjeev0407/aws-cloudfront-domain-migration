[CmdletBinding()]
param(
    [string]$Profile = "",
    [string]$Region = "ap-south-1"
)

$ErrorActionPreference = "Stop"
$TerraformDir = Join-Path $PSScriptRoot "..\terraform"

Push-Location $TerraformDir
try {
    $bucket = terraform output -raw site_bucket_name
    $distributionId = terraform output -raw new_distribution_id
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($bucket)) {
        throw "Terraform outputs unavailable. Run terraform apply first."
    }

    $awsArgs = @()
    if ($Profile) { $awsArgs += @("--profile", $Profile) }

    Write-Host "Uploading site files to private bucket $bucket ..."
    aws s3 sync ..\site "s3://$bucket" --delete --cache-control "public,max-age=300" --region $Region @awsArgs
    if ($LASTEXITCODE -ne 0) { throw "S3 upload failed." }

    Write-Host "Creating CloudFront invalidation for distribution $distributionId ..."
    aws cloudfront create-invalidation --distribution-id $distributionId --paths "/*" @awsArgs
    if ($LASTEXITCODE -ne 0) { throw "CloudFront invalidation failed." }

    Write-Host "Deployment submitted. Check CloudFront invalidation status before declaring completion."
}
finally {
    Pop-Location
}
