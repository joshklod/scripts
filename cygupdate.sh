#!/bin/sh
#
# cygupdate.sh: Windows GUI for updating Cygwin

# Make sure curl is installed
if ! command -v curl >/dev/null 2>&1; then
	echo "Error: cURL not installed. Aborting."
	return 4
fi

# If an argument is provided, it is the local file path
if [ $# -gt 0 ]; then
	patharg="$1"
	if [ -f "$patharg" ]; then
		# Filename is given
		filepath="$patharg"
	elif [ -d "$patharg" ]; then
		# Directory is given
		filepath="$patharg/cygwin-setup.exe"
	elif [ -e "$patharg" ]; then
		# Path exists, but is neither a regular file nor a directory
		echo "Path '$patharg' is neither a regular file nor a directory. Aborting."
		return 1
	else
		# Path does not exist. Assume it is a filename.
		filepath="$patharg"
	fi
else
	# Path not specified. Set to default.
	filepath='/proc/cygdrive/c/applications/cygwin-setup.exe'
fi

# Verify that file is writable
if [ -e "$filepath" ] && [ ! -w "$filepath" ]; then
	echo "File '$filepath' is not writable. Aborting."
	return 2
fi

# Use timestamp checking if file already exists
[ -e "$filepath" ] && time_arg="-z ${filepath//\ /\\\ }"

# Get the file
curl $time_arg -o "$filepath" https://cygwin.com/setup-x86_64.exe || return 3
return 0
