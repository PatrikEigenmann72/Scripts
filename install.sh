#!/bin/sh

show_help() {
cat << EOF | less
NAME
    install.sh - build and prepare project binaries, and installs them in ~/bin

SYNOPSIS
    install.sh [OPTIONS]

DESCRIPTION
    This script takes the active directory as project name and
    compiles the source files in src/ into a binary and drops
    it into bin/. The new binary is then copied to ~/bin/ for easy access.

OPTIONS
    -h, -help, -?   Show this help menu
    -debug          Compile with debug information

EXAMPLES
    install.sh
    install.sh -debug
EOF
}

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

echo "Installing to ~/bin/$PROJECT ..."
mkdir -p "$HOME/bin"
cp "bin/$PROJECT" "$HOME/bin"

echo "Done. Type '$PROJECT' to begin."