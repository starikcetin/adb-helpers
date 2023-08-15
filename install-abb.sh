#!/bin/bash

echo "$(basename $0)"

SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
BUNDLETOOL_PATH="${SCRIPT_PATH}/tools/bundletool.sh"

ABB_PATH=""

printUsage() {
    echo "Usage: install-abb -a <ABB_PATH>"
    echo "  -a ABB_PATH: Path to the ABB file. Required."
}

while getopts "a:b:" OPT; do
    case "${OPT}" in
        a)
            ABB_PATH="${OPTARG}"
        ;;
        *)
			echo "Unrecognized opt: ${OPT}"
            printUsage
            exit 1
        ;;
    esac
done

if [[ -z "${ABB_PATH}" ]] ; then
    echo "-a ABB_PATH is required"
    printUsage
    exit 1
fi

TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')
APKS_PATH="${TEMP_DIR}/x.apks"

"${BUNDLETOOL_PATH}" build-apks --bundle="${ABB_PATH}" --output="${APKS_PATH}"
"${BUNDLETOOL_PATH}" install-apks --apks="${APKS_PATH}"

rm -rf "${TEMP_DIR}"
