# Script:       run-publish.ps1
# Description:  Compile the project and publish it in release mode into
#               "$HOME\bin". "$HOME\bin" is the default location for the
#               published files. "$HOME\bin" is already added to the PATH
#               environment variable, so you can run the published
#               application from any location.
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# ----------------------------------------------------------------------
# Change Log:
# Tue 2025-08-05 File created and content added.          Version: 00.01
# ----------------------------------------------------------------------
dotnet publish `
    -c Release `
    -r win-x64 `
    /p:PublishSingleFile=true `
    /p:TrimUnusedDependencies=true `
    /p:SelfContained=true `
    /p:PublishDir="$HOME\bin"