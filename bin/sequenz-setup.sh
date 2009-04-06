#!/bin/bash

# given a sequenz system definition directory:
#    system-name/config.py
#    system-name/taskdef/(task definition files)

# 1/ generate task class code for sequenz
# 2/ generate system environment script 
#    + this exports PATH and PYTHONPATH, and also 
#      SEQUENZ_ENV (its own path) for system tasks

set -e  # ABORT on error

[[ $# != 1 ]] && {
	echo "USAGE: $0 <system definition dir>"
	echo "should be run in sequenz repo top level"
	exit 1
}

[[ ! -f bin/sequenz.py ]] && {
	echo "RUN THIS IN SEQUENZ REPO TOP LEVEL"
	exit 1
}

SYSDIR=$1
# remove any trailing '/'
SYSDIR=${SYSDIR%/}

ENV_SCRIPT='sequenz-env.sh'

TOPDIR=$PWD

# access to sequenz bin/ for this script
PATH=$PWD/bin:$PATH

cd $SYSDIR

echo "> generating task class code for sequenz: $SYSDIR/task_classes.py"
task_generator.py taskdef/*

# generate system environment script
echo "> generating environment script for this system: $SYSDIR/sequenz-env.sh"
echo "  (the environment script sets PATH and PYTHONPATH for system $SYSDIR)"

cat > $ENV_SCRIPT <<EOF
#!/bin/bash

# AUTO-GENERATED BY $0

# source this to set PATH and PYTHONPATH 
# for running sequenz on system $SYSDIR

# clean existing sequenz paths
      PATH=\$( $TOPDIR/bin/clean_sequenz_path.sh \$PATH )
PYTHONPATH=\$( $TOPDIR/bin/clean_sequenz_path.sh \$PYTHONPATH )

# not using \$HOME or relative path; may be sourced by other users
PATH=$TOPDIR/bin:$TOPDIR/$SYSDIR/tasks:\$PATH
PATH=\${PATH%:}  # in case variable was empty before
PYTHONPATH=$TOPDIR/src:$TOPDIR/$SYSDIR:\$PYTHONPATH
PYTHONPATH=\${PYTHONPATH%:}  # in case was empty before
export PATH PYTHONPATH

# export my location as \$SEQUENZ_ENV
export SEQUENZ_ENV=$TOPDIR/$SYSDIR/$ENV_SCRIPT
EOF
