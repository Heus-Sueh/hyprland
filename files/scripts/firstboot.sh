#!/usr/bin/env bash
set -euo pipefail

# File to indicate that the script has already run
FIRSTBOOT_FILE="$HOME/.config/firstboot/firstboot_done"

# Function to generate a hash and write it to the firstboot file
generate_hash() {
	# Create a unique hash based on the current timestamp and a random number
	local hash
	hash=$(echo "$(date +%s) $RANDOM" | sha256sum | cut -d' ' -f1)
	echo "Hash: $hash" >"$FIRSTBOOT_FILE"
}

# Function to run modular commands and scripts
run_modules() {
	# Add your commands and scripts here that you want to run on the first boot

	# Example commands
	echo "Setting up the environment..."
	# Command to install packages, update the system, etc.
	# sudo apt update && sudo apt upgrade -y

	echo "Running theme setup script..."
	# Example of running an external script
	sudo flatpak override --filesystem=xdg-data/themes
	sudo flatpak override --filesystem=xdg-data/icons
	sudo flatpak override --filesystem=xdg-config/gtk-3.0
	sudo flatpak override --filesystem=xdg-config/gtk-4.0
	sudo flatpak override --filesystem=xdg-config/Kvantum
	# ./setup_theme.sh

	echo "Initial setup completed!"
}

# Check if the script has already run
if [[ ! -f "$FIRSTBOOT_FILE" ]]; then
	echo "First boot detected. Running setup script..."
	run_modules

	# Create the file to indicate that the script has run
	touch "$FIRSTBOOT_FILE"

	# Generate and store the hash in the firstboot file
	generate_hash

	# Disable the systemd service after successful execution
	echo "Disabling firstboot systemd service..."
	sudo systemctl disable firstboot.service

else
	echo "First boot script has already run. Nothing to do."
fi
