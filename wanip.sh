#!/bin/sh
#
# wanip - Returns External IP address

# Shortcut to check command existence
iscommand() { command -v "$@" >/dev/null 2>&1; }

if iscommand dig; then
	dig +short myip.opendns.com @resolver1.opendns.com || exit 1
elif iscommand curl; then
	curl http://whatismyip.akamai.com/ && echo || exit 1
else
	echo "Error: Install either dig or curl" >&2
	exit 1
fi
