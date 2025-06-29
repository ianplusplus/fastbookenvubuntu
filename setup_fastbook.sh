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

# Step 5: Install Mamba
echo ">> Installing Mamba..."
conda install -y -n base -c conda-forge mamba

# Step 6: Clone fastbook
echo ">> Cloning fastbook repository..."
cd $HOME
git clone https://github.com/fastai/fastbook.git
cd fastbook

# Step 7: Configure channels (strict priority)
echo ">> Configuring Conda channels..."
conda config --add channels conda-forge
conda config --add channels fastai
conda config --add channels pytorch
conda config --add channels defaults
conda config --set channel_priority strict

# Step 8: Create environment from environment.yml
echo ">> Creating Conda environment from environment.yml..."
mamba env create -f environment.yml -n fastbook-env || \
mamba env update -f environment.yml -n fastbook-env

# Step 9: Activate environment and register Jupyter kernel
echo ">> Activating environment and registering Jupyter kernel..."
conda activate fastbook-env
python -m ipykernel install --user --name fastbook-env --display-name "Python (fastbook)"

# Step 10: Run test notebook
echo ">> Testing setup with clean.ipynb..."
jupyter nbconvert --to notebook --execute clean.ipynb --output test_output.ipynb

echo ""
echo "✅ Fastbook setup complete!"
echo "To begin working:"
echo "    conda activate fastbook-env"
echo "    jupyter notebook"
echo ""
echo "🚀 You may reboot now to finalize NVIDIA driver installation."
