#!/usr/bin/env bash

# Make bash more sane
set -euo pipefail

theme="$HOME/.config/rofi/screenshot.rasi"
rofi_command="rofi -theme $theme"
dir="$HOME/Pictures/Screenshots"

# Create the directory if it doesn't exist
mkdir -p "$dir"

# Define the filename format
time=$(date +%Y-%m-%d-%I-%M-%S)
file="Screenshot_${time}.png"

# Icons
icon1="$HOME/.config/dunst/icons/collections.svg"
icon2="$HOME/.config/dunst/icons/timer.svg"

# Buttons
layout=$(cat $theme | grep BUTTON | cut -d'=' -f2 | tr -d '[:blank:],*/')
if [[ "$layout" == "TRUE" ]]; then
	screen=""
	area=""
	window="缾"
	infive="靖"
	inten="福"
else
	screen=" Capture Desktop"
	area=" Capture Area"
	window="缾 Capture Window"
	infive="靖 Take in 3s"
	inten="福 Take in 10s"
fi

# Notify and view screenshot
notify_view() {
	dunstify -u low --replace=699 -i "$icon1" "Copied to clipboard."
	if [[ -e "$dir/$file" ]]; then
		dunstify -u low --replace=699 -i "$icon1" "Screenshot Saved."
	else
		dunstify -u low --replace=699 -i "$icon1" "Screenshot Deleted."
	fi
}

# countdown
countdown() {
	for sec in $(seq "$1" -1 1); do
		dunstify -t 1000 --replace=699 -i "$icon2" "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
shotnow() {
	grimshot save output "$dir/$file"
	grimshot copy output "$dir/$file"
	notify_view
}

shot5() {
	countdown '3'
	grimshot save output "$dir/$file"
	grimshot copy output "$dir/$file"
	notify_view
}

shot10() {
	countdown '10'
	grimshot save output "$dir/$file"
	grimshot copy output "$dir/$file"
	notify_view
}

shotwin() {
	grimshot save active "$dir/$file"
	grimshot copy active "$dir/$file"
	notify_view
}

shotarea() {
	grimshot save area "$dir/$file"
	grimshot copy area "$dir/$file"
	notify_view
}

# Variable passed to rofi
options="$screen\n$area\n$window\n$infive\n$inten"

chosen="$(echo -e "$options" | $rofi_command -p 'Take A Screenshot' -dmenu -selected-row 0)"
case $chosen in
$screen)
	shotnow
	;;
$area)
	shotarea
	;;
$window)
	shotwin
	;;
$infive)
	shot5
	;;
$inten)
	shot10
	;;
esac
