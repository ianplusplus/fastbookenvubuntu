#!/bin/bash

set -euo pipefail

echo "=== Fastbook Setup Script for Ubuntu (Python 3.10) ==="

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

# Step 7: Clone fastbook repository
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

# Step 9: Create fastbook environment with Python 3.10
echo ">> Creating Conda environment with Python 3.10..."
mamba create -y -n fastbook-env python=3.10

# Step 10: Activate environment and install required packages
echo ">> Installing fastai and fastbook..."
conda activate fastbook-env
mamba install -y fastbook fastai jupyter notebook ipykernel nbconvert graphviz pip
pip install 'sentencepiece<0.1.90'

# Step 11: Register Jupyter kernel
echo ">> Registering Jupyter kernel..."
python -m ipykernel install --user --name fastbook-env --display-name "Python (fastbook)"

echo ""
echo "✅ Fastbook setup complete!"
echo "To begin working:"
echo "    conda activate fastbook-env"
echo "    jupyter notebook"
echo ""
echo "🚀 Reboot your system now to finalize NVIDIA driver installation."
