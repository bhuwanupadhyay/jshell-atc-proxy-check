#!/bin/bash

# Define the library path
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_PATH="$SCRIPT_DIR/libs"

# Check if the library path exists
if [ ! -d "$LIB_PATH" ]; then
    echo "Creating library path: $LIB_PATH"
    mkdir -p "$LIB_PATH"
fi

prepare_jars(){
    # URL for the JAR file
    DOWNLOAD_JAR_FILE="$1"
    DOWNLOAD_URL="$2"

    # Check if the JAR file already exists; if not, download it
    if [ ! -f "$LIB_PATH/$DOWNLOAD_JAR_FILE" ]; then
        echo "Downloading JAR: $DOWNLOAD_JAR_FILE from URL: $DOWNLOAD_URL"
        if ! curl -o "$LIB_PATH/$DOWNLOAD_JAR_FILE" "$DOWNLOAD_URL"; then
            echo "Failed to download JAR $DOWNLOAD_JAR_FILE from URL: $DOWNLOAD_URL."
            exit 1
        fi
        echo "JAR downloaded successfully."
    fi
}

# read libs.properties file to get url and jar file name
while IFS='=' read -r key value
do
  prepare_jars $key $value
done < "$SCRIPT_DIR/libs.properties"

# Create a temporary directory
TMP=$(mktemp -d)
mkdir -p "$TMP/.java/.systemPrefs"
mkdir -p "$TMP/.java/.userPrefs"
chmod -R 755 "$TMP"

# Prepare the JShell script
tail -n +2 "$@" >> "$TMP/run"
echo "/exit" >> "$TMP/run"

# Set up Java classpath
JAVA_LIBS=$(ls -d "${LIB_PATH}"/*.jar | tr '\n' ':' | sed 's/:$//')
export CLASSPATH="${JAVA_LIBS}"
echo "CLASSPATH: $CLASSPATH"

# Configure Java options
export _JAVA_OPTIONS="-Djava.util.prefs.systemRoot=$TMP/.java -Djava.util.prefs.userRoot=$TMP/.java/.userPrefs"

# Run JShell with the script
jshell -q "$TMP/run"

# Clean up the temporary directory
rm -Rf "$TMP"