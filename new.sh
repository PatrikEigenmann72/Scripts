#!/bin/bash
# --------------------------------------------------------------------------------------------
# Script:       new.sh
# Description:  Create new C projects and modules using templates, parameters,
#               and naming conventions.
# --------------------------------------------------------------------------------------------
# Author:       Patrik Eigenmann
# eMail:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/Scripts
# --------------------------------------------------------------------------------------------
# Change Log:
# Sat 2026-04-25 File created and project functionality added.                 Version: 00.03
# --------------------------------------------------------------------------------------------

# -----------------------------------------
# Parse parameters
# -----------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in

        -project|-p)
            PROJECTNAME="$2"
            shift 2
            ;;

        -module|-m)
            MODULENAME="$2"
            shift 2
            ;;

        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

# -----------------------------------------
# Date formats
# -----------------------------------------
TODAY=$(date +"%a %Y-%m-%d")

# ====================================================================================
# PROJECT GENERATION
# ====================================================================================
if [[ -n "$PROJECTNAME" ]]; then

    echo "Creating project: $PROJECTNAME"

    TEMPLATE_DIR="$HOME/Development/Templates"

    # Namespace = project name
    FILENAME="$PROJECTNAME"

    # Include guard for project
    ALLCAPS_PROJECT=$(echo "$PROJECTNAME" \
        | tr '[:lower:]' '[:upper:]' \
        | sed -e 's/[^A-Z0-9]/_/g')
    ALLCAPS_PROJECT="${ALLCAPS_PROJECT}_H"

    # Create the folder structure
    mkdir -p "$PROJECTNAME"
    mkdir -p "$PROJECTNAME/include"
    mkdir -p "$PROJECTNAME/src"
    mkdir -p "$PROJECTNAME/bin"
    mkdir -p "$PROJECTNAME/resources"
    mkdir -p "$PROJECTNAME/scripts"

    # Copy static templates
    cp "$TEMPLATE_DIR/LICENSE" "$PROJECTNAME/LICENSE"
    cp "$TEMPLATE_DIR/.gitignore" "$PROJECTNAME/.gitignore"

    cp "$TEMPLATE_DIR/readme" "$PROJECTNAME/scripts/readme"
    cp "$TEMPLATE_DIR/readme.ps1" "$PROJECTNAME/scripts/readme.ps1"
    cp "$TEMPLATE_DIR/install.sh" "$PROJECTNAME/scripts/install.sh"
    cp "$TEMPLATE_DIR/install.ps1" "$PROJECTNAME/scripts/install.ps1"

    # Make scripts executable
    chmod +x "$PROJECTNAME/scripts/readme"
    chmod +x "$PROJECTNAME/scripts/install.sh"

    # Generate project header
    sed \
        -e "s/{PROJECT}/$PROJECTNAME/g" \
        -e "s/{ALLCAPS_PROJECT}/$ALLCAPS_PROJECT/g" \
        -e "s/{DATE}/$TODAY/g" \
        -e "s/{FILENAME}/$FILENAME/g" \
        "$TEMPLATE_DIR/project.h" > "$PROJECTNAME/include/$PROJECTNAME.h"

    # Generate project source
    sed \
        -e "s/{PROJECT}/$PROJECTNAME/g" \
        -e "s/{ALLCAPS_PROJECT}/$ALLCAPS_PROJECT/g" \
        -e "s/{DATE}/$TODAY/g" \
        -e "s/{FILENAME}/$FILENAME/g" \
        "$TEMPLATE_DIR/project.c" > "$PROJECTNAME/src/$PROJECTNAME.c"

    # Generate main.c
    sed \
        -e "s/{PROJECT}/$PROJECTNAME/g" \
        -e "s/{ALLCAPS_PROJECT}/$ALLCAPS_PROJECT/g" \
        -e "s/{DATE}/$TODAY/g" \
        "$TEMPLATE_DIR/main.c" > "$PROJECTNAME/src/main.c"

    exit 0
fi

# ====================================================================================
# MODULE GENERATION
# ====================================================================================
if [[ -n "$MODULENAME" ]]; then

    echo "Creating module: $MODULENAME"

    TEMPLATE_DIR="$HOME/Development/Templates"

    # Namespace = module name
    FILENAME="$MODULENAME"

    # Include guard from full namespace
    ALLCAPS_FILENAME=$(echo "$FILENAME" \
        | tr '[:lower:]' '[:upper:]' \
        | sed -e 's/[^A-Z0-9]/_/g')
    ALLCAPS_FILENAME="${ALLCAPS_FILENAME}_H"

    # Generate module header
    sed \
        -e "s/{PROJECT}/$MODULENAME/g" \
        -e "s/{ALLCAPS_FILENAME}/$ALLCAPS_FILENAME/g" \
        -e "s/{DATE}/$TODAY/g" \
        -e "s/{FILENAME}/$FILENAME/g" \
        "$TEMPLATE_DIR/module.h" > "include/$FILENAME.h"

    # Generate module source
    sed \
        -e "s/{PROJECT}/$MODULENAME/g" \
        -e "s/{ALLCAPS_FILENAME}/$ALLCAPS_FILENAME/g" \
        -e "s/{DATE}/$TODAY/g" \
        -e "s/{FILENAME}/$FILENAME/g" \
        "$TEMPLATE_DIR/module.c" > "src/$FILENAME.c"

    exit 0
fi