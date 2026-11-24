[CmdletBinding()]
param(
    [string]$Profile = "",
    [Parameter(Mandatory=$true)][string]$Path = "/*"
)

$ErrorActionPreference = "Stop"
Push-Location (Join-Path $PSScriptRoot "..\terraform")
try {
    $distributionId = terraform output -raw new_distribution_id
    if ($LASTEXITCODE -ne 0) { throw "Unable to read new_distribution_id output." }
    $args = @("cloudfront", "create-invalidation", "--distribution-id", $distributionId, "--paths", $Path)
    if ($Profile) { $args += @("--profile", $Profile) }
    aws @args
    if ($LASTEXITCODE -ne 0) { throw "Invalidation request failed." }
}
finally { Pop-Location }
