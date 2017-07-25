#!/bin/sh
#
# wingit.sh: A wrapper for the Windows version of git that executes in the
#            appropriate environment

# Identify Windows executable
wingitpath="/cygdrive/c/program files/git/bin/git"
# Execute command
HOME="$HOMEDRIVE$HOMEPATH" "$wingitpath" "$@"