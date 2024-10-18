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
  notify-send "Setting up the environment..."
	# Command to install packages, update the system, etc.
	xdg-user-dirs-update

  echo "Initial setup completed!"
  notify-send "Initial setup completed!"
}

# Function to remove the firstboot-related lines from ~/.bashrc
remove_firstboot_lines() {
	# Define the pattern to match the block that runs firstboot
	local start_line="if [[ ! -f \"\$HOME/.config/firstboot/firstboot_done\" ]]; then"
	local end_line="fi"

	# Use sed to delete the lines between the pattern
	sed -i "/$start_line/,/$end_line/d" "$HOME/.bashrc"
}

# Check if the script has already run
if [[ ! -f "$FIRSTBOOT_FILE" ]]; then
	echo "First boot detected. Running setup script..."
  notify-send "First boot detected. Running setup script..."
	run_modules

	# Create the file to indicate that the script has run
	mkdir -p "$(dirname "$FIRSTBOOT_FILE")"

	# Create the file to indicate that the script has run
	touch "$FIRSTBOOT_FILE"

	# Generate and store the hash in the firstboot file
	generate_hash

	# Remove the firstboot lines from ~/.bashrc
	remove_firstboot_lines

else
	echo "First boot script has already run. Nothing to do."
  notify-send "First boot script has already run. Nothing to do."
fi
