Write-Host "=== PowerShell Environment Variable Test ==="
Write-Host "PATH:"
$env:PATH.Split(';') | ForEach-Object { Write-Host " - $_" }