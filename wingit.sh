#!/bin/sh
#
# wingit.sh: Executes the Windows version of git in the appropriate
#            environment

wingitpath="/cygdrive/c/program files/git/bin/git"

[ $# -gt 0 ] && args="$@"

HOME="$HOMEDRIVE$HOMEPATH" "$wingitpath" $args
