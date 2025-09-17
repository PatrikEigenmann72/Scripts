# Script:        new-jproject.ps1
# Description:   Creates a new Java project folder with the complete folder structure and all necessary files inside.
# Author:        Patrik Eigenmann
# email:         p.eigenmann72@gmail.com
# GitHub:        https://github.com/PatrikEigenmann72/PowerShell
# -----------------------------------------------------------------------------
# Change Log:
# Sun 2025-08-17 File created and logic implemented.             Version: 00.01
# Mon 2025-08-18 Refactored folder creation and added manifest.  Version: 00.02
# Mon 2025-08-18 Added App.java copy logic and UTF-8 encoding.   Version: 00.03
# Thu 2025-08-21 Correction in MainFrame.java copy path.         Version: 00.04
# Mon 2025-08-25 Correction in MainFrame.java copy path.         Version: 00.05
# Mon 2025-08-25 Creating the full folder structure first.       Version: 00.06
# -----------------------------------------------------------------------------

param (
    [Parameter(Mandatory = $true)]
    [string]$Name
)

# Resolve paths
# $UserHome    = [Environment]::GetFolderPath("UserProfile")
$SourceApp   = "D:\Documents\Java\HelloJWorld\"
$ProjectRoot = Join-Path (Get-Location) $Name
$lowercaseName = $Name.ToLower()

# Create folders
# New-Item -Path "$ProjectRoot\src" -ItemType Directory -Force | Out-Null
New-Item -Path "$ProjectRoot\src\$lowercaseName\gui" -ItemType Directory -Force | Out-Null

# Copy known-good files from HelloJWorld
Copy-Item "$SourceApp\src\App.java"         "$ProjectRoot\src\App.java"     -Force
Copy-Item "$SourceApp\src\hellojworld\gui\MainFrame.java"   "$ProjectRoot\src\$lowercaseName\gui\MainFrame.java" -Force
Copy-Item "$SourceApp\MANIFEST.mf"          "$ProjectRoot\MANIFEST.mf"      -Force
Copy-Item "$SourceApp\.gitignore"           "$ProjectRoot\.gitignore"       -Force
Copy-Item "$SourceApp\README.md"            "$ProjectRoot\README.md"        -Force
Copy-Item "$SourceApp\LICENSE"              "$ProjectRoot\LICENSE"          -Force

Write-Host "Java project '$Name' created at $ProjectRoot"