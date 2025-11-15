#!/bin/bash

# Installer for brew.sh

# Configuration
BREW_SCRIPT_NAME="homebrew.sh"
INSTALL_DIR="$HOME/bin"
ALIAS_NAME="brew"
BASHRC_FILE="$HOME/.bashrc"
ZSHRC_FILE="$HOME/.zshrc"

# Check if the installation directory exists, create it if not
mkdir -p "$INSTALL_DIR"

# Copy the brew.sh script to the installation directory
cp "$0" "$INSTALL_DIR/$BREW_SCRIPT_NAME"

# Make the script executable
chmod +x "$INSTALL_DIR/$BREW_SCRIPT_NAME"

# Determine which shell configuration file to use
if [ -f "$ZSHRC_FILE" ]; then
  CONFIG_FILE="$ZSHRC_FILE"
  echo "Using Zsh configuration file: $CONFIG_FILE"
elif [ -f "$BASHRC_FILE" ]; then
  CONFIG_FILE="$BASHRC_FILE"
  echo "Using Bash configuration file: $CONFIG_FILE"
else
  echo "Error: No .bashrc or .zshrc file found. Please create one."
  exit 1
fi

# Add the alias to the configuration file (if it's not already there)
if ! grep -q "alias $ALIAS_NAME=" "$CONFIG_FILE"; then
  echo "Adding alias to $CONFIG_FILE"
  echo "alias $ALIAS_NAME=\"$INSTALL_DIR/$BREW_SCRIPT_NAME\"" >> "$CONFIG_FILE"
else
  echo "Alias already exists in $CONFIG_FILE"
fi

# Source the configuration file
echo "Sourcing $CONFIG_FILE to activate the alias"
source "$CONFIG_FILE"

echo "Installation complete! You can now use the homebrew for debian based os."