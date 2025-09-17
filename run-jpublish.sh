#!/bin/bash
# Script:       run-jpublish.sh
# Description:  Package compiled classes into a JAR with manifest pointing to App.
#               Output goes to "$HOME/bin" for clean separation from debug builds.
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# ----------------------------------------------------------------------
# Change Log:
# Thu 2025-08-14 File created and content added.          Version: 00.01
# ----------------------------------------------------------------------

buildDir="build"
manifest="MANIFEST.MF"
projectName="$(basename "$(pwd)")"
jarName="$projectName.jar"
targetDir="$HOME/.local/bin"

# Ensure target directory exists
mkdir -p "$targetDir"

# Create manifest file
cat > "$manifest" <<EOF
Manifest-Version: 1.0
Main-Class: App
EOF

echo "Packaging $jarName into $targetDir..."
jar cfm "$targetDir/$jarName" "$manifest" -C "$buildDir" .

echo "Published to $targetDir/$jarName"