#!/bin/bash
# A simple build script for C projects. It compiles all .c files in src/ and outputs the binary to bin/ with the same name as the current directory.
show_help() {
cat << EOF | less
NAME
    compile.sh - build and prepare project binaries

SYNOPSIS
    compile.sh [OPTIONS]

DESCRIPTION
    This script takes the active directory as project name and
    compiles the source files in src/ into a binary and drops
    it into bin/.

OPTIONS
    -h, -help, -?   Show this help menu
    -debug          Compile with debug information

EXAMPLES
    compile.sh
    compile.sh -debug
EOF
}

# Parse arguments
for arg in "$@"; do
    case $arg in
        -h|-help|-\?)
            show_help
            exit 0
            ;;
        # add other options here
    esac
done

set -e

# Extract project name from current directory
PROJECT="$(basename "$PWD")"

echo "Building $PROJECT..."
mkdir -p bin

if [ "$1" = "-debug" ]; then
  echo "Compiling with DEBUG flag..."
  gcc -Wall -Wextra -std=c99 -Iinclude src/*.c -o "bin/$PROJECT" -DDEBUG
else
  gcc -Wall -Wextra -std=c99 -Iinclude src/*.c -o "bin/$PROJECT"
fi

echo "Done. Type 'bin/$PROJECT' to begin."