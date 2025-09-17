#!/bin/bash
# Script: jbuild.sh
# ************************************************************************************
# The script jbuild.sh compiles all Java files (*.java) in the current directory and
# its subfolders. Steps to do that:
# 1. It looks for a classpath.txt file in the current directory. If it finds one,
#    it reads the classpath from that file. Lines starting with '#' are ignored.
#    If the file is not found, it proceeds without external libraries.
# 2. It uses the 'find' command to search for all files with the .java extension in
#    the current directory and all of its subdirectories. The paths of these files are
#    listed in a file named sources.txt.
# 3. It uses the 'javac' command to compile all the Java files listed in sources.txt.
#    The @ symbol tells 'javac' to read file names from the sources.txt file.
# 4. It checks if the 'javac' command executed successfully by examining its exit status.
#    If the exit status is 0, the compilation was successful; otherwise, it failed.
# 5. It prints a message to the terminal indicating whether the compilation was successful
#    or failed.
# 6. Finally, it cleans up by removing the sources.txt file, as it is no longer needed
#    after compilation.
# ------------------------------------------------------------------------------------
# Author:   Patrik Eigenmann
# eMail:    p.eigenmann@gmx.net
# GitHub:   www.github.com/PatrikEigenmann/bash
# ------------------------------------------------------------------------------------
# Change Log:
# Tue 2023-06-13 File created.                                          Version: 00.01
# Sun 2025-03-17 Added support for external libraries via classpath.txt.Version: 00.02
# Tue 2025-09-09 Compile in build folder.                               Version: 00.03
# ************************************************************************************

# Check if classpath.txt exists in the current directory
if [ -f "classpath.txt" ]; then
    # Read classpath from file, ignoring lines that start with '#'
    CLASSPATH=$(grep -v '^#' classpath.txt | tr '\n' ':')
    echo "Using classpath: $CLASSPATH"
else
    echo "classpath.txt not found. Proceeding without external libraries."
    CLASSPATH="."
fi

# Find all Java files in the current directory and its subdirectories
find . -name "*.java" > sources.txt

# Compile all found Java files with the provided classpath
javac -cp "$CLASSPATH" -d build @sources.txt

# Check if the compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful."
else
    echo "Compilation failed."
    exit 1
fi

# Clean up the sources.txt file
rm sources.txt

# Run the application
java -cp "build:$CLASSPATH" App -debug