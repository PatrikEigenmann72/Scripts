#!/bin/bash
# Script:       get-jcomponent.sh
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
SOURCE_ROOT="/Users/patrik/Development/Java/HelloJWorld/src"
TARGET_ROOT="$(pwd)/src"

if [ -z "$1" ]; then
    echo "Usage: $0 <Component> (e.g., samael.huginandmunin.Log.java or samael.huginandmunin.*)"
    exit 1
fi

COMPONENT="$1"

if [[ "$COMPONENT" == *".*" ]]; then
    BASE_COMPONENT="${COMPONENT%.*}"
    RELATIVE_PATH="${BASE_COMPONENT//.//}"
    SOURCE_FOLDER="$SOURCE_ROOT/$RELATIVE_PATH"
    TARGET_FOLDER="$TARGET_ROOT/$RELATIVE_PATH"

    if [ -d "$SOURCE_FOLDER" ]; then
        mkdir -p "$TARGET_FOLDER"
        cp -r "$SOURCE_FOLDER/"* "$TARGET_FOLDER/"
        echo -e "Copied folder: $SOURCE_FOLDER -> $TARGET_FOLDER"
    else
        echo -e "Folder not found: $SOURCE_FOLDER"
    fi

elif [[ "$COMPONENT" == *.java ]]; then
    BASE_NAME="${COMPONENT%.java}"
    DOT_INDEX=$(awk -v str="$BASE_NAME" 'BEGIN{print index(str, ".")}')
    if [ "$DOT_INDEX" -eq 0 ]; then
        echo -e "Invalid component format: $COMPONENT"
        exit 1
    fi

    FOLDER_PART="${BASE_NAME%.*}"
    CLASS_NAME="${BASE_NAME##*.}"
    RELATIVE_PATH="${FOLDER_PART//.//}"
    SOURCE_FOLDER="$SOURCE_ROOT/$RELATIVE_PATH"
    TARGET_FOLDER="$TARGET_ROOT/$RELATIVE_PATH"
    SOURCE_FILE="$SOURCE_FOLDER/$CLASS_NAME.java"
    TARGET_FILE="$TARGET_FOLDER/$CLASS_NAME.java"

    if [ -f "$SOURCE_FILE" ]; then
        mkdir -p "$TARGET_FOLDER"
        cp "$SOURCE_FILE" "$TARGET_FILE"
        echo -e "Copied file: $SOURCE_FILE -> $TARGET_FILE"
    else
        echo -e "File not found: $SOURCE_FILE"
    fi

else
    echo -e "Invalid component format: $COMPONENT"
fi