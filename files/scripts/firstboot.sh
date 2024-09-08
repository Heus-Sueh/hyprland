#!/usr/bin/env bash
set -euo pipefail

# File to indicate that the script has already run
FIRSTBOOT_FILE="$HOME/.config/firstboot/firstboot_done"

# Function to generate a hash and write it to the firstboot file
generate_hash() {
	# Create a unique hash based on the current timestamp and a random number
	local hash
	hash=$(echo "$(date +%s) $RANDOM" | sha256sum | cut -d' ' -f1)
	echo "$hash" >"$FIRSTBOOT_FILE"
}

# Function to run modular commands and scripts
run_modules() {
	# Add your commands and scripts here that you want to run on the first boot

	# Example commands
	echo "Setting up the environment..."
	# Command to install packages, update the system, etc.
	xdg-user-dirs-update

	echo "Running theme setup script..."
	# Commands that require root privileges
	pkexec bash -c '
        flatpak override --filesystem=xdg-data/themes
        flatpak override --filesystem=xdg-data/icons
        flatpak override --filesystem=xdg-config/gtk-3.0
        flatpak override --filesystem=xdg-config/gtk-4.0
        flatpak override --filesystem=xdg-config/Kvantum
    '

	echo "Initial setup completed!"
}

# Check if the script has already run
if [[ ! -f "$FIRSTBOOT_FILE" ]]; then
	echo "First boot detected. Running setup script..."
	run_modules

	# Create the file to indicate that the script has run
	mkdir -p "$(dirname "$FIRSTBOOT_FILE")"

	# Create the file to indicate that the script has run
	touch "$FIRSTBOOT_FILE"

	# Generate and store the hash in the firstboot file
	generate_hash

else
	echo "First boot script has already run. Nothing to do."
fi
