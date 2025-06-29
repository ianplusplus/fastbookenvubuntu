#!/bin/bash

set -euo pipefail

echo "=== Fastbook Setup Script for Ubuntu ==="

# Step 1: Update system
echo ">> Updating system..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install NVIDIA drivers
echo ">> Installing NVIDIA drivers..."
sudo ubuntu-drivers autoinstall
sudo apt install -y build-essential dkms

# Step 3: Install wget and git
sudo apt install -y wget git

# Step 4: Install Anaconda (if not already installed)
ANACONDA_INSTALLER=Anaconda3-2024.02-1-Linux-x86_64.sh
if [ ! -f "$ANACONDA_INSTALLER" ]; then
    echo ">> Downloading Anaconda..."
    wget https://repo.anaconda.com/archive/$ANACONDA_INSTALLER
fi

echo ">> Installing Anaconda..."
bash $ANACONDA_INSTALLER -b -p $HOME/anaconda3
eval "$($HOME/anaconda3/bin/conda shell.bash hook)"
conda init
source ~/.bashrc

# Step 5: Configure conda to always confirm
echo ">> Setting conda to always confirm..."
conda config --set always_yes true

# Step 6: Install Mamba
echo ">> Installing Mamba..."
conda install -n base -c conda-forge mamba

# Step 7: Clone fastbook
echo ">> Cloning fastbook repository..."
cd $HOME
git clone https://github.com/fastai/fastbook.git || (cd fastbook && git pull)
cd fastbook

# Step 8: Configure Conda channels with strict priority
echo ">> Configuring Conda channels with strict priority..."
conda config --add channels conda-forge
conda config --add channels fastai
conda config --add channels pytorch
conda config --add channels defaults
conda config --set channel_priority strict

# Step 9: Create environment from environment.yml
echo ">> Creating Conda environment from environment.yml..."
mamba env create -y -f environment.yml -n fastbook-env || mamba env update -y -f environment.yml -n fastbook-env

# Step 10: Activate environment, install Jupyter components, and register kernel
echo ">> Activating environment and installing Jupyter tools..."
conda activate fastbook-env
mamba install -y ipykernel notebook nbconvert
python -m ipykernel install --user --name fastbook-env --display-name "Python (fastbook)"

# Step 11: Run test notebook (01_intro.ipynb from fastbook repo)
echo ">> Testing setup with 01_intro.ipynb..."
jupyter nbconvert --to notebook --execute 01_intro.ipynb --output test_output.ipynb --allow-errors

echo ""
echo "✅ Fastbook setup complete!"
echo "To begin working:"
echo "    conda activate fastbook-env"
echo "    jupyter notebook"
echo ""
echo "🚀 You may reboot now to finalize NVIDIA driver installation."
