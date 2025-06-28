#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade the system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Download Miniconda installer
echo "Downloading Miniconda installer..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

# Make installer executable
chmod +x ~/miniconda.sh

# Run the installer (non-interactive)
echo "Installing Miniconda..."
bash ~/miniconda.sh -b -p $HOME/miniconda

# Initialize conda
echo "Initializing conda..."
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
conda init

# Clean up installer
rm ~/miniconda.sh

# Reload shell to apply conda to environment
exec "$SHELL"

echo "Miniconda installation complete!"
