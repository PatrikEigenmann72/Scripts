# Script:       get-jcomponent.ps1
# Description:  Copies Java component files or folders from
#               "D:\Documents\Java\HelloJWorld\src" to the active ".\src"
#               directory. Supports dot-path resolution and wildcard matching.
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# -----------------------------------------------------------------------------
# Change Log:
# Sun 2025-08-17 File created and logic implemented.            Version: 00.01
# Sun 2025-08-17 Replaced Join-Path with string interpolation.  Version: 00.02
# Mon 2025-08-18 Removed wildcard fallback for .java.           Version: 00.03
# Mon 2025-08-18 Fixed dot-path resolution for .java.           Version: 00.04
# -----------------------------------------------------------------------------

param (
    [Parameter(Mandatory = $true)]
    [string]$Component  # e.g., "Samael.HuginAndMunin.Log.java" or "Samael.HuginAndMunin.*"
)

# Resolve paths
# $UserHome      = [Environment]::GetFolderPath("UserProfile")
$SourceRoot    = "D:\Documents\Java\HelloJWorld\src"
$TargetRoot    = "$PWD\src"

# Folder copy: ends with .*
if ($Component.EndsWith('.*')) {
    $baseComponent = $Component.Substring(0, $Component.Length - 2)
    $relativePath  = $baseComponent -replace '\.', '\'
    $sourceFolder  = "$SourceRoot\$relativePath"
    $targetFolder  = "$TargetRoot\$relativePath"

    if (Test-Path $sourceFolder) {
        New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
        Copy-Item -Path "$sourceFolder\*" -Destination $targetFolder -Recurse -Force
        Write-Host "Copied folder: $sourceFolder -> $targetFolder" -ForegroundColor Green
    } else {
        Write-Host "Folder not found: $sourceFolder" -ForegroundColor Red
    }
}
# File copy: ends with .java
elseif ($Component -like '*.java') {
    if (-not $Component.EndsWith(".java")) {
        Write-Host "Invalid component format: $Component" -ForegroundColor Yellow
        return
    }

    $baseName = $Component.Substring(0, $Component.Length - 5)  # remove ".java"
    $dotIndex = $baseName.LastIndexOf(".")
    if ($dotIndex -lt 0) {
        Write-Host "Invalid component format: $Component" -ForegroundColor Yellow
        return
    }

    $folderPart   = $baseName.Substring(0, $dotIndex)
    $className    = $baseName.Substring($dotIndex + 1)
    $relativePath = $folderPart -replace '\.', '\'
    $sourceFolder = "$SourceRoot\$relativePath"
    $targetFolder = "$TargetRoot\$relativePath"
    $sourceFile   = "$sourceFolder\$className.java"
    $targetFile   = "$targetFolder\$className.java"

    if (Test-Path $sourceFile) {
        New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
        Copy-Item -Path $sourceFile -Destination $targetFile -Force
        Write-Host "Copied file: $sourceFile -> $targetFile" -ForegroundColor Green
    } else {
        Write-Host "File not found: $sourceFile" -ForegroundColor Red
    }
}
# Invalid format
else {
    Write-Host "Invalid component format: $Component" -ForegroundColor Yellow
}