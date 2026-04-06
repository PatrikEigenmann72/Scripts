#!/bin/bash
# ------------------------------------------------------------------------------------
# Script:       jcompile.sh
# Description:  Find all Java files in the src folder, and subfolders. Delete the
#               build folder if it exists. Then compile them into the build folder.
#               If classpath.txt is present, use it for the classpath. After compilation,
#               clean up the sources.txt file and delete it.
# ------------------------------------------------------------------------------------
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/Scripts
# ------------------------------------------------------------------------------------
# Change Log:
# Thu 2025-08-14 File created and content added.                        Version: 00.01
# Wed 2025-09-17 Adding all classes from build folder.                  Version: 00.02
# Wed 2025-09-17 Resources folder added.                                Version: 00.03
# Sat 2026-04-04 Split run-jbuild.sh in jcompile.sh and jrun.sh.        Version: 00.04
# ------------------------------------------------------------------------------------

# Remove old build folder if it exists
if [ -d "build" ]; then
    rm -rf build
fi

# Check if classpath.txt exists in the current directory
if [ -f "classpath.txt" ]; then
    CLASSPATH=$(grep -v '^#' classpath.txt | tr '\n' ':')
    echo "Using classpath: $CLASSPATH"
else
    echo "classpath.txt not found. Proceeding without external libraries."
    CLASSPATH="."
fi

# Find all Java files in the src folder and its subdirectories
find src -name "*.java" > sources.txt

# Compile all found Java files with the provided classpath
javac -cp "$CLASSPATH" -d build @sources.txt

# Check if the compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful."
fi

# Always clean up
rm sources.txt