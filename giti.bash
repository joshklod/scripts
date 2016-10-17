#!/bin/bash
#
# giti.bash: An interactive prompt for Git

# File to store command history (WIP)
history_file="$HOME/.giti_history"

# Colors
blue="\e[34;22m"
bgreen="\e[32;1m"
cyan="\e[36;22m"
bcyan="\e[36;1m"
yellow="\e[33;22m"
reset="\e[0m"

# Get current working info and print prompt
prompt() {
	local head
	
	if [ -f .git/HEAD ]; then
		head=$(< .git/HEAD)
		
		if [[ "$head" = *refs/heads/* ]]; then
			if [ $COLORS -ge 8 ]; then
				head="${cyan}HEAD $yellow-> $bgreen${head##*/}"
			else
				head="HEAD -> ${head##*/}"
			fi
		else
			if [ $COLORS -ge 8 ]; then
				head="${cyan}HEAD $yellow-> ${head:0:7}"
			else
				head="HEAD -> ${head:0:7}"
			fi
		fi
	else
		head="Not in a Git repository"
	fi
	
	printf "$printf_str" "${PWD/#$HOME/\~}" "$head"
}

# Set prompt:
# GIT wdir (HEAD)
# >
if [ $COLORS -ge 8 ]; then
	printf_str="\n${blue}GIT $cyan%s $yellow(%b$yellow)\n$cyan> $reset"
else
	printf_str="\nGIT %s (%s)\n> "
fi

# If history file doesn't exist, create it
[ ! -f "$history_file" ] && touch "$history_file"

# Main command loop
while [ ! $exit_flag ]; do
	prompt
	
	read -er
	case "$REPLY" in
		"")   continue ;;
		exit) exit_flag=1 ;;
		!*)
			eval "${REPLY:1}"
			;;
		*)
			if [[ "$REPLY" =~ ^[[:blank:]]*(cd|ls|git)([[:blank:]].*)?$ ]]; then
				eval "$REPLY"
			else
				git $REPLY
			fi
	esac
done
