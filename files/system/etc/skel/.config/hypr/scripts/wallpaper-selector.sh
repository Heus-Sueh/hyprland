#!/bin/env bash
# Make bash more sane
set -euo pipefail

# This script is for selecting wallpapers (Modifier + whatever)
export PATH=$PATH:$HOME/.local/bin
ROFI_THEME="$HOME/.config/rofi/wallpaper-selector.rasi"
SWAY_SCRIPTS="$HOME/.config/sway/scripts"

# Path to wallpapers
PICTURES_PATH=$(xdg-user-dir PICTURES)
WALLPAPER_DIR="$PICTURES_PATH/Wallpapers/wallhaven"

# Retrieve image files (including subdirectories)
PICS=($(find "${WALLPAPER_DIR}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \)))
RANDOM_PIC="${PICS[RANDOM % ${#PICS[@]}]}"

# List of all types:
# scheme-content
# scheme-expressive
# scheme-fidelity
# scheme-fruit-salad
# scheme-monochrome
# scheme-neutral
# scheme-rainbow
# scheme-tonal-spot

MODE="dark"
SCHEME_TYPE="scheme-fidelity"
MATUGEN_ARGS="-m $MODE -v -t $SCHEME_TYPE --show-colors --debug"

INTERFACE="org.gnome.desktop.interface"
WM_PREFERENCES="org.gnome.desktop.wm.preferences"

# Rofi command
ROFI_COMMAND="rofi -dmenu -theme $ROFI_THEME"

# Function to generate the menu
menu() {
	printf "Random\n"
	for pic in "${PICS[@]}"; do
		# Display .gif to indicate animated images
		if [[ ! "${pic}" =~ \.gif$ ]]; then
			printf "$(basename "${pic}" | cut -d. -f1)\x00icon\x1f${pic}\n"
		else
			printf "$(basename "${pic}" | cut -d. -f1)\n"
		fi
	done
}

# Update Hyprpaper config
update_hyprpaper() {
	HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
	# Replace the line that starts with $wallpaper with the new path
	sed -i "s|^\(\$wallpaper = \).*|\1$1|" "$HYPRPAPER_CONF"
}

# Update Swaybg config
update_swaybg() {
	SWAYBG_CONF="$HOME/.config/sway/wallpaper.conf"
	# Remove the existing exec_always line
	sed -i '/^exec_always swaybg/d' "$SWAYBG_CONF"
	# Add the new wallpaper path
	echo "exec_always swaybg -i $1 -m fill -o '*'" >>"$SWAYBG_CONF"
}

# Main function
main() {
	choice=$(menu | ${ROFI_COMMAND})

	# Exit if no choice is made
	if [[ -z $choice ]]; then
		exit 0
	fi

	# Kill swaybg if running, only if a choice is made
	if pidof swaybg >/dev/null; then
		pkill swaybg
	fi

	# Handle random choice
	if [[ "$choice" == "Random" ]]; then
		matugen image $RANDOM_PIC $MATUGEN_ARGS
		gsettings set $INTERFACE gtk-theme adw-gtk3-dark
		gsettings set $WM_PREFERENCES theme 'adw-gtk3-dark'
		update_hyprpaper "$RANDOM_PIC"
		update_swaybg "$RANDOM_PIC"
		swaymsg reload
		exit 0
	fi

	# Find the selected file
	selected_file=""
	for file in "${PICS[@]}"; do
		if [[ "$(basename "$file" | cut -d. -f1)" == "$choice" ]]; then
			selected_file="$file"
			break
		fi
	done

	if [[ -n "$selected_file" ]]; then
		matugen image $selected_file $MATUGEN_ARGS
		gsettings set $INTERFACE gtk-theme adw-gtk3-dark
		gsettings set $WM_PREFERENCES theme 'adw-gtk3-dark'

		if pgrep -x "Hyprland" >/dev/null; then
			update_hyprpaper "$RANDOM_PIC"
			hyprctl reload
		elif pgrep -x "sway" >/dev/null; then
			update_swaybg "$RANDOM_PIC"
			swaymsg reload
		fi
	else
		echo "Wallpaper not found."
		exit 1
	fi
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
	pkill rofi
	exit 0
fi

main
