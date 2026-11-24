$ErrorActionPreference = "Stop"
node (Join-Path $PSScriptRoot "redirect-function.test.js")
if ($LASTEXITCODE -ne 0) { throw "Redirect Function tests failed." }
Write-Host "All local tests passed."
