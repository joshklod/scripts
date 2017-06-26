#!/bin/bash
#
# giti.bash: An interactive prompt for Git

# Enable alias expansion
shopt -s expand_aliases

# Colors
 faint='\x01\e[0;2m\x02'
 green='\x01\e[32;22m\x02'
bgreen='\x01\e[32;1m\x02'
yellow='\x01\e[33;22m\x02'
 bblue='\x01\e[34;1m\x02'
 reset='\x01\e[0m\x02'

## Environment variable defaults
HISTFILE="${GITI_HISTFILE:-$HOME/.giti_history}" # History file
: ${GITI_ALIASES:=$HOME/.bash_aliases}           # User aliases file
: ${COLORS:=$(tput colors)}                      # TODO Make this smarter

# Prompt
# GIT wdir head
# >
if [ $COLORS -ge 8 ]; then
	: ${GITI_PS1="\n${green}GIT $bblue%s  %b\n$bblue> $reset"}
else
	: ${GITI_PS1="\nGIT %s  (%s)\n> "}
fi

# Get current working info and print prompt
prompt() {
	local head
	local head_color
	
	if [ -f .git/HEAD ]; then
		head=$(< .git/HEAD)
		
		if [[ "$head" = *refs/heads/* ]]; then
			head="${head##*refs/heads/}"
			head_color="$bgreen"
		else
			head="${head:0:7}"
			head_color="$yellow"
		fi
	else
		head="Not in a Git repository"
		head_color="$faint"
	fi

	if [ $COLORS -ge 8 ]; then
		head="$head_color$head$reset"
	fi
	
	printf "$GITI_PS1" "${PWD/#$HOME/\~}" "$head"
}

commands() {
	local aliases
	local commandlist
	
	# Regenerate every loop in case aliases change
	aliases="$(
		git config -l |
		sed -e '/^[\t ]*alias/!d' -e 's/alias.//' -e 's/=.*//' |
		tr '\n' '|'
	)"
	
	commandlist="$corecommands$aliases"
	echo -n "(${commandlist%|})"
}

# Generate list of Git commands
corecommands="$(
	find -L "$(git --exec-path)" -type f -name git-* -perm /111 -print0 |
	sed -z -e "s:.*/git-::" -e "s/\.exe$//" |
	tr '\0' '|'
)"

# Source aliases file
[ -f "$GITI_ALIASES" ] && source "$GITI_ALIASES"

# Read history file into current session history
history -r

# Main command loop
while [ ! $exit_flag ]; do
	read -erp "$(prompt)"
	history -s "$REPLY" # Add command to history
	
	case "$REPLY" in
		"")   continue ;;
		exit) exit_flag=1 ;;
		!*)   eval "${REPLY:1}" ;;
		*)
			if [[ "$REPLY" =~ ^[[:blank:]]*$(commands)([[:blank:]].*)?$ ]]
			then
				eval "git $REPLY"
			else
				eval "$REPLY"
			fi
	esac
done

# Write current session history to history file
history -w
