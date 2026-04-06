#!/bin/bash
# ------------------------------------------------------------------------------------
# Script:       jrun.sh
# Description:  Run the compiled Java application by executing the App class in debug mode.
#               command: java --cp ".:build:$CLASSPATH" App -debug
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

# Check if classpath.txt exists in the current directory
if [ -f "classpath.txt" ]; then
    CLASSPATH=$(grep -v '^#' classpath.txt | tr '\n' ':')
    echo "Using classpath: $CLASSPATH"
else
    echo "classpath.txt not found. Proceeding without external libraries."
    CLASSPATH="."
fi

# Run the application in debug mode
java -cp ".:build:$CLASSPATH" App -debug