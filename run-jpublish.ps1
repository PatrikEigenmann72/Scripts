# Script:       run-jpublish.ps1
# Description:  Package compiled classes into a JAR with manifest pointing
#               to App as main class and add all resources. Output goes to
#               "$HOME\bin" for clean separation from debug builds.
# ------------------------------------------------------------------------
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# ------------------------------------------------------------------------
# Change Log:
# Thu 2025-08-14 File created and content added.            Version: 00.01
# Wed 2025-09-17 All classes from the build folder added.   Version: 00.02
# Wed 2025-09-17 Resources folder added.                    Version: 00.03
# ------------------------------------------------------------------------

$buildDir = "build"
$manifest = "MANIFEST.MF"
$projectName = (Get-Item -Path ".").Name
$jarName = "$projectName.jar"
$targetDir = "$HOME\bin"

# Ensure target directory exists
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

# Create manifest file
@"
Manifest-Version: 1.0
Main-Class: App
"@ | Set-Content $manifest -Encoding ASCII

Write-Host "Packaging $jarName into $targetDir..."
jar cfm "$targetDir\$jarName" $manifest -C $buildDir . resources

Write-Host "Published to $targetDir\$jarName"