#!/bin/bash
echo "$(basename $0)"
SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
java -jar "${SCRIPT_PATH}/bundletool.jar" "$@"
