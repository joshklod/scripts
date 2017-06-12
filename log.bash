#!/bin/bash
#
# log.bash: Run command with output redirected to logfile

# Default mode
mode="stdout"

# Default directory to contain logfile
[ -z "$LOGDIR" ] && LOGDIR="$HOME/.logs"

# Create directory if it does not exist, or default to $HOME
[ ! -d "$LOGDIR" ] && { mkdir "$LOGDIR" || LOGDIR="$HOME"; }

# Process commandline args
while [[ $1 == -* ]]; do
	case "$1" in
		-o | --stdout ) mode="stdout" ;;
		-e | --stderr ) mode="stderr" ;;
		-b | --both   ) mode="both"   ;;
		* )
			echo "Unknown option '$1'" >&2
			exit 1
			;;
	esac
	shift
done

# Name of logfile is name of command
logfile="$LOGDIR/${1##*/}.log";

# Notify user of logging
echo -e "Writing to $logfile...\n"

# Execute the rest in the background
{
	# Append a header indicating start of new log
	echo -e "\n\n################ LOG $(date) ###############\n" >> "$logfile"
	# Execute command depending on mode
	case "$mode" in
		stdout ) "$@"  >> $logfile      ;;
		stderr ) "$@" 2>> $logfile      ;;
		both   ) "$@"  >> $logfile 2>&1 ;;
	esac
	# Timestamp end of program execution
	echo -e "\n######## Program Terminated $(date) ########\n" >> "$logfile"
} &
