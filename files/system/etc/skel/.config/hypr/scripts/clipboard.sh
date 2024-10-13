#!/usr/bin/env bash

set -euo pipefail

# Configurations
term="alacritty"
theme="$HOME/.local/share/rofi/themes/minimal/style.rasi"

# Check which clipboard manager is available
if command -v cliphist &>/dev/null; then
	clipboard_manager="cliphist"
elif command -v clipman &>/dev/null; then
	clipboard_manager="clipman"
else
	echo "No supported clipboard manager found."
	exit 1
fi

# Get clipboard content based on the available manager
case $clipboard_manager in
cliphist)
	clipboard_content=$(cliphist list)
	;;
clipman)
	clipboard_content=$(clipman pick -t STDOUT)
	;;
*)
	echo "Unsupported clipboard manager."
	exit 1
	;;
esac

# Use rofi to display clipboard content and select an item
selected_item=$(echo "$clipboard_content" | rofi \
	-dmenu \
	-p "Clipboard History" \
	-scroll-method 0 \
	-terminal "$term" \
	-kb-cancel Escape \
	-theme "$theme")

# If an item was selected, check if it is an image or text
if [[ -n "$selected_item" ]]; then
	case $clipboard_manager in
	cliphist)
		# Check if the selected item is binary data (indicating an image)
		if [[ "$selected_item" == *"[ binary data"* ]]; then
			# Extract the index of the selected binary item
			index=$(echo "$selected_item" | awk '{print $1}')
			# Retrieve the image content
			cliphist decode "$index" | wl-copy --type image/png
		else
			# Remove the index and leading whitespace before storing
			selected_content=$(echo "$selected_item" | awk '{$1=""; print $0}' | sed 's/^ *//')
			echo -ne "$selected_content" | cliphist store
			wl-copy "$selected_content" # Copy only the selected text
		fi
		;;
	clipman)
		# Assuming clipman does not store images in history
		echo -ne "$selected_item" | clipman store
		;;
	*)
		echo "Unsupported clipboard manager."
		exit 1
		;;
	esac
fi
