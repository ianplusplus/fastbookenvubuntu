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

# Step 4: Install Anaconda
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

# Step 5: Configure conda
echo ">> Setting conda defaults..."
conda config --set always_yes true

# Step 6: Install Mamba
echo ">> Installing Mamba..."
conda install -n base -c conda-forge mamba

# Step 7: Clone fastbook
echo ">> Cloning fastbook repository..."
cd $HOME
git clone https://github.com/fastai/fastbook.git || (cd fastbook && git pull)

# Step 8: Configure Conda channels
echo ">> Configuring Conda channels..."
conda config --add channels conda-forge
conda config --add channels fastai
conda config --add channels pytorch
conda config --set channel_priority strict

# Step 9: Create environment
echo ">> Creating Conda environment: fastbook-env (Python 3.10)"
mamba create -n fastbook-env python=3.10 -y

# Step 10: Activate environment and install packages
echo ">> Installing core packages..."
conda activate fastbook-env
mamba install -y fastbook fastai jupyter notebook ipykernel nbconvert graphviz "sentencepiece<0.1.90"

# Step 11: Register Jupyter kernel
echo ">> Registering Jupyter kernel..."
python -m ipykernel install --user --name fastbook-env --display-name "Python (fastbook)"

echo ""
echo "✅ Fastbook environment setup complete!"
echo ""
echo "To begin working:"
echo "    conda activate fastbook-env"
echo "    jupyter notebook"
echo ""
echo "🚀 Please reboot your system to enable GPU support (if drivers were installed)."
