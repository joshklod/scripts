#!/bin/sh

for bg in 9 0 1 2 3 4 5 6 7; do
	for bold in 22 1 2; do
		for fg in 9 0 1 2 3 4 5 6 7; do
			echo -en "\e[3${fg};4${bg};${bold}mAbcd\e[0m  "
		done
		echo
	done
done
