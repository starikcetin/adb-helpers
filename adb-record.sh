#!/bin/bash

echo "$(basename $0)"

KEEP_ON_PHONE=false
FILE_NAME="screen_recording_$(date +"%Y-%m-%d_%H-%M")"
TARGET_DIR_PHONE="//sdcard"
TARGET_DIR_COMP="$(pwd)"

printUsage() {
    echo "Usage: adb-record [-k] [-f <FILE_NAME>] [-p <TARGET_DIR_PHONE>] [-c <TARGET_DIR_COMP>]"
    echo "  -k KEEP_ON_PHONE: Keep the video file on the phone. Default '${KEEP_ON_PHONE}'."
    echo "  -f FILE_NAME: Name of the video file. No extension. Default screen_recording_<date>_<time>.mp4."
    echo "  -p TARGET_DIR_PHONE: Target directory on the phone. Default '${TARGET_DIR_PHONE}'."
    echo "  -c TARGET_DIR_COMP: Target directory on the computer. Default pwd."
}

while getopts "hkf:p:c:" OPT; do
    case "${OPT}" in
        k)
            KEEP_ON_PHONE=true
        ;;
        f)
            FILE_NAME="${OPTARG}"
        ;;
        p)
            TARGET_DIR_PHONE="${OPTARG}"
        ;;
        c)
            TARGET_DIR_COMP="${OPTARG}"
        ;;
        *)
            printUsage
            exit 1
        ;;
    esac
done

FULL_PATH_PHONE="${TARGET_DIR_PHONE}/${FILE_NAME}.mp4"
FULL_PATH_COMP="${TARGET_DIR_COMP}/${FILE_NAME}.mp4"

mkdir -p "${TARGET_DIR_COMP}"

function finish() {
    adb shell "pkill -SIGINT screenrecord"
    adb pull "${FULL_PATH_PHONE}" "${FULL_PATH_COMP}"
	
	if ! ${KEEP_ON_PHONE} ; then 
		adb shell "rm '${FULL_PATH_PHONE}'"
	fi
}

trap finish SIGINT

echo "Press Ctrl+C to stop screen recording."

adb shell "screenrecord '${FULL_PATH_PHONE}'"
