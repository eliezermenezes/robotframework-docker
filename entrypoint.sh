#!/bin/bash

ROBOT_LOG_TITLE="Docker Robot Framework Test Logs"
ROBOT_REPORT_TITLE="Docker Robot Framework Test Report"

# No need for the overhead of pabot if we only have one thread
if [ "${ROBOT_THREADS}" -eq 1 ]; then
    robot \
        --logtitle "${ROBOT_LOG_TITLE}" \
        --reporttitle "${ROBOT_REPORT_TITLE}" \
        "$@"
else
    pabot \
        --processes "${ROBOT_THREADS}" \
        --logtitle "${ROBOT_LOG_TITLE}" \
        --reporttitle "${ROBOT_REPORT_TITLE}" \
        "$@"
fi
