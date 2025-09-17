# Script:       run-jbuild.ps1
# Description:  Regenerate sources.txt, compile all Java sources, and run App.class.
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# ----------------------------------------------------------------------
# Change Log:
# Thu 2025-08-14 File created and content added.          Version: 00.01
# ----------------------------------------------------------------------

$srcDir = "src"
$sourcesFile = "sources.txt"

#Write-Host "Generating $sourcesFile from $srcDir..."
Get-ChildItem -Path $srcDir -Recurse -Filter *.java |
    ForEach-Object { $_.FullName } |
    Set-Content $sourcesFile -Encoding ASCII

#Write-Host "Compiling sources..."
javac --% -d .\build @sources.txt

#Write-Host "Running App.class..."
java -cp .\build App -debug