#!/bin/bash
# ------------------------------------------------------------------------------------
# Script:       jnew.sh
# Description:  Create new Java projects and Java classes using templates, parameters,
#               and naming conventions. Supports imports, inheritance, interfaces,
#               enums, constructors, and main method generation.
# ------------------------------------------------------------------------------------
# Author:       Patrik Eigenmann
# eMail:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/Scripts
# ------------------------------------------------------------------------------------
# Change Log:
# Wed 2026-04-15 File created and project functionallity added.         Version: 00.01
# Thu 2026-04-16 Added -class support.                                  Version: 00.02
# Sat 2026-04-18 Added -interface support.                              Version: 00.03
# Sun 2026-04-19 Added -enum support.                                   Version: 00.04
# ------------------------------------------------------------------------------------

# -----------------------------------------
# Parse parameters
# -----------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in

        -project|-p)
            PROJECTNAME="$2"
            shift 2
            ;;

        -class|-c)
            CLASSNAME="$2"
            MODE="class"
            shift 2
            ;;

        -interface|-intf)
            INTERFACENAME="$2"
            MODE="interface"
            shift 2
            ;;

        -enum|-e)
            ENUMNAME="$2"
            MODE="enum"
            shift 2
            ;;

        -package|-pkg)
            PACKAGENAME="$2"
            shift 2
            ;;

        -import|-i)
            IMPORTLIST="$2"
            shift 2
            ;;

        -extend)
            EXTENDLIST="$2"
            shift 2
            ;;

        -implement)
            IMPLEMENTLIST="$2"
            shift 2
            ;;

        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done


# ====================================================================================
# PROJECT GENERATION
# ====================================================================================
if [[ -n "$PROJECTNAME" && -z "$MODE" ]]; then

    echo "Creating project: $PROJECTNAME"

    TEMPLATE_DIR="$HOME/Development/Templates"

    mkdir -p "$PROJECTNAME"
    mkdir -p "$PROJECTNAME/resources/audio"
    mkdir -p "$PROJECTNAME/resources/config"
    mkdir -p "$PROJECTNAME/resources/css"
    mkdir -p "$PROJECTNAME/resources/html"
    mkdir -p "$PROJECTNAME/resources/icons"
    mkdir -p "$PROJECTNAME/resources/manpage"
    mkdir -p "$PROJECTNAME/src"

    mkdir -p "$PROJECTNAME/manifest"
    echo "Manifest-Version: 1.0" > "$PROJECTNAME/manifest/MANIFEST.MF"
    echo "Main-Class: App" >> "$PROJECTNAME/manifest/MANIFEST.MF"

    cp "$TEMPLATE_DIR/LICENSE" "$PROJECTNAME/LICENSE"
    cp "$TEMPLATE_DIR/.gitignore" "$PROJECTNAME/.gitignore"
    cp "$TEMPLATE_DIR/Config.txt" "$PROJECTNAME/resources/config/${PROJECTNAME}.txt"

    sed "s/{PROJECT}/$PROJECTNAME/g" "$TEMPLATE_DIR/README.md" > "$PROJECTNAME/README.md"

    TODAY=$(date +"%a %Y-%m-%d")
    sed "s/{DATE}/$TODAY/g" "$TEMPLATE_DIR/App.java" > "$PROJECTNAME/src/App.java"

    echo "Project $PROJECTNAME created successfully."
    exit 0
fi


# ====================================================================================
# COMMON LOGIC FOR CLASS / INTERFACE / ENUM
# ====================================================================================
if [[ "$MODE" == "class" || "$MODE" == "interface" || "$MODE" == "enum" ]]; then

    TEMPLATE_DIR="$HOME/Development/Templates"
    TODAY=$(date +"%a %Y-%m-%d")
    PROJECTNAME=$(basename "$PWD")

    # PACKAGE HANDLING
    if [[ -n "$PACKAGENAME" ]]; then
        PACKAGEPATH=$(echo "$PACKAGENAME" | tr '.' '/')
        mkdir -p "src/$PACKAGEPATH"
        TARGETDIR="src/$PACKAGEPATH"
        PACKAGE_LINE="package $PACKAGENAME;"
    else
        mkdir -p "src"
        TARGETDIR="src"
        PACKAGE_LINE=""
    fi

    # IMPORT HANDLING
    if [[ -n "$IMPORTLIST" ]]; then
        IMPORTS=$(echo "$IMPORTLIST" | tr ',' '\n' | sed 's/^/import /; s/$/;/')
    else
        IMPORTS=""
    fi

    # EXTEND HANDLING (class OR interface only)
    if [[ -n "$EXTENDLIST" ]]; then
        EXTEND=" extends $(echo "$EXTENDLIST" | sed 's/,/, /g')"
    else
        EXTEND=""
    fi
fi


# ====================================================================================
# ENUM GENERATION
# ====================================================================================
if [[ "$MODE" == "enum" ]]; then

    # Enums cannot extend classes or implement interfaces
    if [[ -n "$EXTENDLIST" ]]; then
        echo "Error: enums cannot extend classes. Remove -extend."
        exit 1
    fi

    if [[ -n "$IMPLEMENTLIST" ]]; then
        echo "Error: enums cannot implement interfaces using -implement."
        exit 1
    fi

    TARGETFILE="$TARGETDIR/${ENUMNAME}.java"

    sed \
        -e "s/{FILENAME}/${ENUMNAME}.java/g" \
        -e "s/{PROJECT}/$PROJECTNAME/g" \
        -e "s/{DATE}/$TODAY/g" \
        -e "s|{PACKAGE}|$PACKAGE_LINE|g" \
        -e "s|{IMPORT}|$IMPORTS|g" \
        -e "s/{COMPONENT}/$ENUMNAME/g" \
        "$TEMPLATE_DIR/Enum.java" \
        > "$TARGETFILE"

    echo "Enum $ENUMNAME created at $TARGETFILE"
    exit 0
fi


# ====================================================================================
# INTERFACE GENERATION
# ====================================================================================
if [[ "$MODE" == "interface" ]]; then

    if [[ -n "$IMPLEMENTLIST" ]]; then
        echo "Error: interfaces cannot implement interfaces. Use -extend instead."
        exit 1
    fi

    TARGETFILE="$TARGETDIR/${INTERFACENAME}.java"

    sed \
        -e "s/{FILENAME}/${INTERFACENAME}.java/g" \
        -e "s/{PROJECT}/$PROJECTNAME/g" \
        -e "s/{DATE}/$TODAY/g" \
        -e "s|{PACKAGE}|$PACKAGE_LINE|g" \
        -e "s|{IMPORT}|$IMPORTS|g" \
        -e "s/{COMPONENT}/$INTERFACENAME/g" \
        -e "s|{EXTEND}|$EXTEND|g" \
        "$TEMPLATE_DIR/Interface.java" \
        > "$TARGETFILE"

    echo "Interface $INTERFACENAME created at $TARGETFILE"
    exit 0
fi


# ====================================================================================
# CLASS GENERATION
# ====================================================================================
if [[ "$MODE" == "class" ]]; then

    TARGETFILE="$TARGETDIR/${CLASSNAME}.java"

    if [[ -n "$IMPLEMENTLIST" ]]; then
        IMPLEMENT=" implements $(echo "$IMPLEMENTLIST" | sed 's/,/, /g')"
    else
        IMPLEMENT=""
    fi

    sed \
        -e "s/{FILENAME}/${CLASSNAME}.java/g" \
        -e "s/{PROJECT}/$PROJECTNAME/g" \
        -e "s/{DATE}/$TODAY/g" \
        -e "s|{PACKAGE}|$PACKAGE_LINE|g" \
        -e "s|{IMPORT}|$IMPORTS|g" \
        -e "s|{EXTEND}|$EXTEND|g" \
        -e "s|{IMPLEMENT}|$IMPLEMENT|g" \
        -e "s/{KEYWORD}/public/g" \
        -e "s/{COMPONENT}/$CLASSNAME/g" \
        "$TEMPLATE_DIR/Class.java" \
        > "$TARGETFILE"

    echo "Class $CLASSNAME created at $TARGETFILE"
    exit 0
fi