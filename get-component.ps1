# Script:       get-component.ps1
# Description:  Copies library files or a specific file from
#               "D:\Documents\CSharp\HelloWorld" to the active "." directory.
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# ----------------------------------------------------------------------
# Change Log:
# Mon 2025-08-04 File created and content added.          Version: 00.01
# Tue 2025-08-05 Minor updates and improvements.          Version: 00.02
# Wed 2025-08-06 Added wildcard * support.                Version: 00.03
# ----------------------------------------------------------------------
param (
    [Parameter(Mandatory=$true)]
    [string]$Component  # e.g., "Samael.HuginAndMunin.Debug.cs" or "Samael.*"
)

# Fixed source directory
$SourceDir = "D:\Documents\CSharp\HelloWorld"

# Get matching files
$matchedFiles = Get-ChildItem -Path $SourceDir -Filter $Component -File

if ($matmatchedFiles.Count -eq 0) {
    Write-Host "No matching files found for pattern: $Component" -ForegroundColor Red
    return
}

foreach ($file in $matchedFiles) {
    $targetPath = Join-Path (Get-Location) $file.Name
    try {
        Copy-Item -Path $file.FullName -Destination $targetPath -Force
        Write-Host "Copied: $($file.Name) -> $targetPath" -ForegroundColor Green
    } catch {
        Write-Host "Failed to copy: $($file.Name)" -ForegroundColor Yellow
    }
}