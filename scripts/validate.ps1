[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$OldDomain,
    [Parameter(Mandatory=$true)][string]$NewDomain,
    [string]$Profile = ""
)

$ErrorActionPreference = "Stop"

function Get-HeaderValue([string]$Url, [string]$HeaderName) {
    $result = & curl.exe -sS -I $Url
    if ($LASTEXITCODE -ne 0) { throw "curl failed for $Url" }
    $line = $result | Where-Object { $_ -match ("(?i)^" + [regex]::Escape($HeaderName) + ":") } | Select-Object -Last 1
    if ($line) { return ($line -replace "^[^:]+:\s*", "").Trim() }
    return ""
}

$testPath = "/migration-check/path?source=portfolio&campaign=aws"
$oldUrl = "https://$OldDomain$testPath"
$newUrl = "https://$NewDomain/"

Write-Host "`n[1] Old-domain redirect"
$oldHeaders = & curl.exe -sS -I $oldUrl
$oldHeaders | ForEach-Object { Write-Host $_ }
$location = Get-HeaderValue $oldUrl "Location"
$expected = "https://$NewDomain$testPath"
if ($location -ne $expected) {
    throw "Redirect mismatch. Expected '$expected' but received '$location'."
}
Write-Host "PASS: 301 Location preserves URI and query string."

Write-Host "`n[2] New-domain response"
$newHeaders = & curl.exe -sS -I $newUrl
$newHeaders | ForEach-Object { Write-Host $_ }
if (($newHeaders -join "`n") -notmatch "200") {
    Write-Warning "A 200 response was not detected. Confirm distribution deployment and site upload."
} else {
    Write-Host "PASS: New-domain endpoint returned HTTP 200."
}

Write-Host "`n[3] HTTP-to-HTTPS behavior"
$httpHeaders = & curl.exe -sS -I "http://$NewDomain/"
$httpHeaders | ForEach-Object { Write-Host $_ }
if (($httpHeaders -join "`n") -match "(?i)location:\s*https://") {
    Write-Host "PASS: HTTP redirects to HTTPS."
} else {
    Write-Warning "HTTP redirect header not detected; inspect CloudFront viewer protocol policy."
}

Write-Host "`nValidation finished. Review warnings and test both apex and www hostnames."
