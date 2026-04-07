#!/bin/bash
# Script:       jget.sh
# Description:  Copy specified Java component (class or package) from source
#               directory to target project src directory.
# ----------------------------------------------------------------------------
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/Scripts
# ----------------------------------------------------------------------------
# Change Log:
# Thu 2025-09-19 File created and content added.                Version: 00.01
# Tue 2026-04-07 Preserve application-specific Config.java.     Version: 00.02
# Tue 2026-04-08 Script get-jcomponent.sh renamed to jget.sh.   Version: 00.03
# Tue 2026-04-08 Added Samael auto-dependencies.                Version: 00.04
# ----------------------------------------------------------------------------

SOURCE_ROOT="/Users/patrik/Development/Java/HelloJWorld/src"
TARGET_ROOT="$(pwd)/src"

# ----------------------------------------------------------------------------
# Preserve application-specific Config.java
# ----------------------------------------------------------------------------
CONFIG_PATH="$TARGET_ROOT/samael/chronicle/Config.java"
BACKUP_PATH="./Config.java_temp"

if [[ -f "$CONFIG_PATH" ]]; then
    cp "$CONFIG_PATH" "$BACKUP_PATH"
    echo "Preserved application Config.java"
fi

# ----------------------------------------------------------------------------
# Auto-Dependency Section:
# If the requested component is from the Samael-framework (starts with "samael."),
# then make sure all the dependencies are copied into the active project too.
#
# Dependencies (all framework classes are relying on these classes):
#   - samael.alchemy.Name.java
#   - samael.huginandmunin.Debug.java
# ----------------------------------------------------------------------------

AUTO_DEPENDENCIES() {
    # samael.alchemy.Name
    mkdir -p "$TARGET_ROOT/samael/alchemy/"
    cp "$SOURCE_ROOT/samael/alchemy/Name.java" \
       "$TARGET_ROOT/samael/alchemy/Name.java"

    # samael.huginandmunin.Debug
    mkdir -p "$TARGET_ROOT/samael/huginandmunin/"
    cp "$SOURCE_ROOT/samael/huginandmunin/Debug.java" \
       "$TARGET_ROOT/samael/huginandmunin/Debug.java"

    echo "Auto-dependencies copied (Name.java, Debug.java)"
}

# ----------------------------------------------------------------------------

if [ -z "$1" ]; then
    echo "Usage: $0 <Component> (e.g., samael.huginandmunin.Log.java or samael.huginandmunin.*)"
    exit 1
fi

COMPONENT="$1"

# Trigger auto-dependencies BEFORE copying the requested component
if [[ "$COMPONENT" == samael.* ]]; then
    AUTO_DEPENDENCIES
fi

# ----------------------------------------------------------------------------
# Component Copy Logic
# ----------------------------------------------------------------------------

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

# ----------------------------------------------------------------------------
# Restore application-specific Config.java
# ----------------------------------------------------------------------------
if [[ -f "$BACKUP_PATH" ]]; then
    mv "$BACKUP_PATH" "$CONFIG_PATH"
    echo "Restored application Config.java"
fi

exit 0