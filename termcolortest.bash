#!/bin/bash

res=38
res2=$((2*$res))

case "$1" in
	-24 | --24 )
		for y in $(seq 0 2 $res); do
			echo

			g=$(($y*256/$res))

			if   [ $g -lt   0 ]; then g=0
			elif [ $g -gt 255 ]; then g=255
			fi

			for x in $(seq 0 $res2); do
				xy=$(($x + $y))
				if   [ $xy -le $res ];  then r=255
				elif [ $xy -ge $res2 ]; then r=0
				else                         r=$((512 - $xy*256/$res))
				fi

				if   [ $r -lt   0 ]; then r=0
				elif [ $r -gt 255 ]; then r=255
				fi

				xy=$(($x + ($res - $y)))
				if   [ $xy -le $res ];  then b=0
				elif [ $xy -ge $res2 ]; then b=255
				else                         b=$(($xy*256/$res - 256))
				fi

				if   [ $b -lt   0 ]; then b=0
				elif [ $b -gt 255 ]; then b=255
				fi

				echo -en "\e[48;2;$r;$g;${b}m \e[0m"
			done
		done
		echo
		;;

	-256 | --256 )
		for color1 in 0 8; do
			echo
			for color2 in $(seq 0 7); do
				color=$((color1 + color2))
				echo -en "\e[48;5;${color}m  \e[0m"
			done
		done
		echo

		for color1 in $(seq 16 36 196); do
			echo
			for color2 in $(seq 0 35); do
				color=$((color1 + color2))
				echo -en "\e[48;5;${color}m  \e[0m"
			done
		done
		echo

		echo
		for color in $(seq 232 255); do
			echo -en "\e[48;5;${color}m  \e[0m"
		done
		echo
		;;

	*)
		for bg in 9 0 1 2 3 4 5 6 7; do
			for bold in 22 1 2; do
				echo
				for fg in 9 0 1 2 3 4 5 6 7; do
					echo -en "\e[3${fg};4${bg};${bold}mAbcd\e[0m  "
				done
			done
		done
		echo
		;;
esac

