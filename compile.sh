#!/bin/sh
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

echo "Done. Type '$PROJECT' to begin."