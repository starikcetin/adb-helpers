#!/bin/bash

echo "$(basename $0)"
SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

ABB_PATH=""
KEYSTORE_PATH=""
KEYSTORE_PASS=""
KEY_ALIAS=""
KEY_PASS=""

printUsage() {
    echo "Usage: install-abb --bundle <ABB_PATH> [--ks <KEYSTORE_PATH> --ks-pass <KEYSTORE_PASS> --ks-key-alias <KEY_ALIAS> --key-pass <KEY_PASS>]"
    echo "  --bundle ABB_PATH: Path to the ABB file. Required."
    echo "  --ks KEYSTORE_PATH: Path to the ABB file."
    echo "  --ks-pass KEYSTORE_PASS: Path to the ABB file."
    echo "  --ks-key-alias KEY_ALIAS: Path to the ABB file."
    echo "  --key-pass KEY_PASS: Path to the ABB file."
}

while [ "${1:-}" != "" ]; do
    case "${1}" in
        "--bundle") shift; ABB_PATH="${1}";;
        "--ks") shift; KEYSTORE_PATH="${1}";;
        "--ks-pass") shift; KEYSTORE_PASS="${1}";;
        "--ks-key-alias") shift; KEY_ALIAS="${1}";;
        "--key-pass") shift; KEY_PASS="${1}";;
        *)
            echo "Unrecognized opt: ${1}"
            printUsage
            exit 1
        ;;
    esac
    shift
done

if [[ -z "${ABB_PATH}" ]] ; then
    echo "-a ABB_PATH is required"
    printUsage
    exit 1
fi

if (( (0 ${KEYSTORE_PATH:++1} ${KEYSTORE_PASS:++1} ${KEY_ALIAS:++1} ${KEY_PASS:++1}) % 4 != 0 ))
then
    echo "You need to either define all opts regarding the keystore, or none of them."
    printUsage
    exit 1
fi

BUNDLETOOL_PATH="${SCRIPT_PATH}/tools/bundletool.sh"
TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')
APKS_PATH="${TEMP_DIR}/x.apks"

if [ -z "${KEYSTORE_PATH}" ] ; then 
    "${BUNDLETOOL_PATH}" build-apks --bundle="${ABB_PATH}" --output="${APKS_PATH}"
else
    "${BUNDLETOOL_PATH}" build-apks --bundle="${ABB_PATH}" --output="${APKS_PATH}" \
    --ks="${KEYSTORE_PATH}" \
    --ks-pass="pass:${KEYSTORE_PASS}" \
    --ks-key-alias="${KEY_ALIAS}" \
    --key-pass="pass:${KEY_PASS}"
fi

"${BUNDLETOOL_PATH}" install-apks --apks="${APKS_PATH}"

rm -rf "${TEMP_DIR}"
