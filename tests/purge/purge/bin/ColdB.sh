#!/bin/bash

set -eu

echo "Hello from $CYLC_TASK_NAME at $CYLC_TASK_CYCLE_TIME in $CYLC_SUITE_REG_NAME"
sleep $TASK_EXE_SECONDS

touch $RUNNING_DIR/B-${CYLC_TASK_CYCLE_TIME}.restart
