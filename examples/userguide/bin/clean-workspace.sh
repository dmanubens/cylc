#!/bin/bash

usage="USAGE: clean-workspace.sh PATH"

if [[ $# != 1 ]]; then
    echo $usage >&2
    exit 1
fi

echo "Hello from $TASK_NAME at $CYCLE_TIME in $CYLC_SUITE_NAME"

if [[ $# == 1 ]]; then
    WORKSPACE=$1
else
    echo "No workspace specified for cleaning"
    exit 1
fi

echo "Cleaning $WORKSPACE ..."

rm -rf $WORKSPACE
mkdir -p $WORKSPACE

echo "Done"