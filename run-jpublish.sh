#!/bin/bash
# Script:       run-jpublish.sh
# Description:  Package compiled classes into a JAR with manifest pointing
#               to App as main class and add all resources. Output goes to
#               "$HOME/bin" for clean separation from debug builds.
# ------------------------------------------------------------------------
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# ------------------------------------------------------------------------
# Change Log:
# Thu 2025-08-14 File created and content added.            Version: 00.01
# Wed 2025-09-17 Adding all classes from build folder.      Version: 00.02
# Wed 2025-09-17 Resources folder added.                    Version: 00.03
# ------------------------------------------------------------------------

buildDir="build"
manifest="MANIFEST.MF"
projectName="$(basename "$(pwd)")"
jarName="$projectName.jar"
targetDir="$HOME/bin"

# Ensure target directory exists
mkdir -p "$targetDir"

# Create manifest file
cat > "$manifest" <<EOF
Manifest-Version: 1.0
Main-Class: App
EOF

echo "Packaging $jarName into $targetDir..."
jar cfm "$targetDir/$jarName" "$manifest" -C "$buildDir" . resources

echo "Published to $targetDir/$jarName"