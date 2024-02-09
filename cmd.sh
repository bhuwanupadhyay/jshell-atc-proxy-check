#!/bin/bash

# Get the current directory
CURRENT_DIR=$(dirname "$0")

# Specify the path to wrapper relative to the current directory
WRAPPER="$CURRENT_DIR/wrapper.sh"

# Check if the wrapper script exists
if [ -x "$WRAPPER" ]; then
    "$WRAPPER" "$@"
else
    echo "wrapper not found in the current directory."
    exit 1
fi