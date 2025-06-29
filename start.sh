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

# Step 3: Install wget, git, and system deps
sudo apt install -y wget git libsentencepiece-dev

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

# Step 9: Create environment manually for Python 3.10
echo ">> Creating Conda environment 'fastbook-env'..."
mamba create -y -n fastbook-env python=3.10

# Step 10: Activate environment and install packages
echo ">> Installing fastai, fastbook, and required packages..."
conda activate fastbook-env
mamba install -y jupyterlab notebook ipykernel nbconvert matplotlib pandas scikit-learn
mamba install -y fastai fastbook

# Step 11: Install sentencepiece via pip
echo ">> Installing compatible sentencepiece version via pip..."
pip install 'sentencepiece<0.1.90'

# Step 12: Register Jupyter kernel
python -m ipykernel install --user --name fastbook-env --display-name "Python (fastbook)"

echo ""
echo "✅ Fastbook environment setup complete!"
echo "To begin working:"
echo "    conda activate fastbook-env"
echo "    jupyter lab"
echo ""
echo "🚀 You may reboot now to finalize NVIDIA driver installation."
