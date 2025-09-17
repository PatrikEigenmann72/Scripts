# Script:       toggle.ps1
# Description:  Toggles the file extensions of Program.cs and Program.txt.
#               This is great in WinForms development, where you might want
#               to switch between Console app and WinForms app. WinForms is
#               your main app, and the console app is used for debugging.
#               Both files "Program.cs" and "Program.txt" must exist in the
#               same directory for the toggle to work.
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# ----------------------------------------------------------------------
# Change Log:
# Tue 2025-08-05 File created and content added.          Version: 00.01
# ----------------------------------------------------------------------
$csFile = "Program.cs"
$txtFile = "Program.txt"
$tmpFile = "Program.tmp"

if ((Test-Path $csFile) -and (Test-Path $txtFile)) {
    Rename-Item -Path $csFile -NewName $tmpFile
    Rename-Item -Path $txtFile -NewName $csFile
    Rename-Item -Path $tmpFile -NewName $txtFile
    Write-Host "Swapped Program.cs and Program.txt successfully."
} else {
    Write-Host "Both Program.cs and Program.txt must exist for the swap."
}