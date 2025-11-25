#!/bin/bash

show_help() {
cat << EOF | less
NAME
    get-ccomponent.sh - copy C components from template project

SYNOPSIS
    get-ccomponent.sh [COMPONENT]

DESCRIPTION
    Copies C source/header files from the template project into the active project.
    Behavior is determined by the suffix of COMPONENT:

        foo.c       -> copy foo.c from template src/ to active src/
        foo.h       -> copy foo.h from template include/ to active include/
                       if foo.c exists in template src/, copy it too
        foo         -> copy both foo.c and foo.h if they exist

OPTIONS
    -h, --help     Show this help menu

EXAMPLES
    get-ccomponent.sh foo.c
    get-ccomponent.sh samael.chronicle.config.h
    get-ccomponent.sh samael.chronicle.config
EOF
}

TEMPLATE=/Users/patrik/Development/cpp/helloworld
DEST_SRC=src
DEST_INC=include

# Fail fast
set -e

# Parse arguments
if [[ $# -eq 0 ]]; then
    show_help
    exit 1
fi

case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    *.c)
        FILE=$(basename "$1")
        echo "$TEMPLATE/$DEST_SRC/$FILE"
        if [[ -f "$TEMPLATE/$DEST_SRC/$FILE" ]]; then
            mkdir -p "$DEST_SRC"
            cp "$TEMPLATE/$DEST_SRC/$FILE" "$DEST_SRC/"
            echo "Copied $FILE to $DEST_SRC/"
        else
            echo "Source file not found in template: $FILE"
        fi
        ;;
    *.h)
        FILE=$(basename "$1")
        echo "$TEMPLATE/$DEST_INC/$FILE"
        BASE="${FILE%.h}"
        if [[ -f "$TEMPLATE/$DEST_INC/$FILE" ]]; then
            mkdir -p "$DEST_INC"
            cp "$TEMPLATE/$DEST_INC/$FILE" "$DEST_INC/"
            echo "Copied $FILE to $DEST_INC/"
            # Check for counterpart .c
            if [[ -f "$TEMPLATE/$DEST_SRC/$BASE.c" ]]; then
                mkdir -p "$DEST_SRC"
                cp "$TEMPLATE/$DEST_SRC/$BASE.c" "$DEST_SRC/"
                echo "Copied counterpart $BASE.c to $DEST_SRC/"
            fi
        else
            echo "Header file not found in template: $FILE"
        fi
        ;;
    *)
        BASE="$1"
        if [[ -f "$TEMPLATE/$DEST_SRC/$BASE.c" ]]; then
            mkdir -p "$DEST_SRC"
            cp "$TEMPLATE/$DEST_SRC/$BASE.c" "$DEST_SRC/"
            echo "Copied $BASE.c to $DEST_SRC/"
        fi
        if [[ -f "$TEMPLATE/$DEST_INC/$BASE.h" ]]; then
            mkdir -p "$DEST_INC"
            cp "$TEMPLATE/$DEST_INC/$BASE.h" "$DEST_INC/"
            echo "Copied $BASE.h to $DEST_INC/"
        fi
        ;;
esac