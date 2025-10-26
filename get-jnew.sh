#!/bin/bash
# Script:       get-jnew.sh
# Description:  Copy specified Java component (class or package) from source
#               directory to target project src directory.
# ----------------------------------------------------------------------------
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/Scripts
# ----------------------------------------------------------------------------
# Change Log:
# Thu 2025-09-19 File created and content added.                Version: 00.01
# ----------------------------------------------------------------------------

# Template paths
CLASS_TEMPLATE="/Users/patrik/Development/Templates/Class.java"
ENUM_TEMPLATE="/Users/patrik/Development/Templates/Enum.java"
INTERFACE_TEMPLATE="/Users/patrik/Development/Templates/Interface.java"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p)
      PACKAGE_PATH="$2"
      shift 2
      ;;
    -c)
      CLASS_NAME="$2"
      TEMPLATE_TYPE="class"
      shift 2
      ;;
    -e)
      ENUM_NAME="$2"
      TEMPLATE_TYPE="enum"
      shift 2
      ;;
    -i)
      INTERFACE_NAME="$2"
      TEMPLATE_TYPE="interface"
      shift 2
      ;;
    -k)
      KEYWORD="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
done

# Validate input
if [[ -z "$PACKAGE_PATH" ]]; then
  echo "Error: Package path (-p) is required."
  exit 1
fi

# Ensure only one of -c, -e, or -i is used
TYPES_SET=0
[[ -n "$CLASS_NAME" ]] && ((TYPES_SET++))
[[ -n "$ENUM_NAME" ]] && ((TYPES_SET++))
[[ -n "$INTERFACE_NAME" ]] && ((TYPES_SET++))

if [[ $TYPES_SET -ne 1 ]]; then
  echo "Error: Specify exactly one of -c, -e, or -i."
  exit 1
fi

# Create target directory
TARGET_DIR="./src/${PACKAGE_PATH//.//}"
mkdir -p "$TARGET_DIR"

# Select template and filename
case "$TEMPLATE_TYPE" in
  class)
    TEMPLATE="$CLASS_TEMPLATE"
    FILENAME="$CLASS_NAME"
    ;;
  enum)
    TEMPLATE="$ENUM_TEMPLATE"
    FILENAME="$ENUM_NAME"
    ;;
  interface)
    TEMPLATE="$INTERFACE_TEMPLATE"
    FILENAME="$INTERFACE_NAME"
    ;;
  *)
    echo "Error: No valid template type specified."
    exit 1
    ;;
esac

# Format values
TODAY=$(date +"%a %Y-%m-%d")
COMPONENT="${FILENAME%.*}"
PROJECT_NAME=$(basename "$PWD")
DEST_FILE="$TARGET_DIR/$FILENAME"

KEYWORD="${KEYWORD:-}"

if [[ -z "${KEYWORD// }" ]]; then
  KEYWORD=""
fi

# Copy template
cp "$TEMPLATE" "$DEST_FILE"

# Replace placeholders
sed -i '' \
  -e "s/%DATE%/$TODAY/g" \
  -e "s/%FILENAME%/$FILENAME/g" \
  -e "s/%COMPONENT%/$COMPONENT/g" \
  -e "s/%PROJECT%/$PROJECT_NAME/g" \
  -e "s/%PACKAGE%/$PACKAGE_PATH/g" \
  -e "s/%KEYWORD%/$KEYWORD/g" \
  "$DEST_FILE"

echo "Created $DEST_FILE from $TEMPLATE"