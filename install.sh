#!/bin/bash
set -e

# Configuration
SOURCE_DIR="skills/unjail"
DEST_BASE="$HOME/.gemini/antigravity/skills"
DEST_DIR="$DEST_BASE/unjail"

echo "Installing Unjail Skill..."

# Create destination directory if it doesn't exist
mkdir -p "$DEST_BASE"

# Copy the skill directory
if [ -d "$SOURCE_DIR" ]; then
    # Remove existing if any to ensure clean install
    rm -rf "$DEST_DIR"
    cp -r "$SOURCE_DIR" "$DEST_BASE/"
    echo "Files copied to $DEST_DIR"
else
    echo "Error: Source directory $SOURCE_DIR not found!"
    exit 1
fi

# Set executable permissions
chmod +x "$DEST_DIR/scripts/unjail_runner.sh"
echo "Permissions set for runner script."

# Check for dependencies
if ! command -v jq &> /dev/null; then
    echo "Note: 'jq' is missing. The runner will use a fallback, but installing 'jq' is recommended for better output."
fi

echo "--------------------------------------------------------"
echo "Installation complete!"
echo "To use the skill, run the runner in your workspace root:"
echo "  $DEST_DIR/scripts/unjail_runner.sh"
echo "--------------------------------------------------------"
