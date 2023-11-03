#!/bin/bash

# This script imports a package from Fedora sources into the Aoyama tree.

# Usage: import-from-fedora.sh <package-name> <?path>

FEDORA_GIT="https://src.fedoraproject.org/rpms"

# check for arg $1

if [ -z "$1" ]; then
    echo "Usage: import-from-fedora.sh <package-name> <?path>"
    exit 1
fi

PACKAGE="$1"

# arg $2 is optional, if not given, use "pkgs/$1" as default

CLONE_DEST="pkgs/$1"

if [ -n "$2" ]; then
    CLONE_DEST="$2"
fi

# check if $CLONE_DEST already exists

if [ -d "$CLONE_DEST" ]; then
    echo "Error: $CLONE_DEST already exists"
    exit 1
fi

clone_and_clean() {
    git clone "$FEDORA_GIT/$1" "$CLONE_DEST"
    rm -rf "$CLONE_DEST/.git"

    # heredoc create $CLONE_DEST/anda.hcl
    cat <<EOF >"$CLONE_DEST/anda.hcl"
project "pkg" {
    rpm {
        spec = "$PACKAGE.spec"
    }
}
EOF
}


clone_and_clean "$PACKAGE"