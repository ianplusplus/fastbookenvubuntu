#!/bin/bash

set -e  # Exit on any error
set -u  # Treat unset variables as error

echo "=== Fastbook Setup Script for Ubuntu ==="

# Step 1: Update system
echo ">> Updating system..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install NVIDIA drivers
echo ">> Installing NVIDIA drivers..."
sudo ubuntu-drivers autoinstall
echo ">> NVIDIA drivers installed. You may need to reboot later."

# Step 3: Install dependencies for NVIDIA CUDA (optional but good to have)
sudo apt install -y build-essential dkms

# Step 4: Install wget and git if not present
sudo apt install -y wget git

# Step 5: Install Anaconda
ANACONDA_INSTALLER=Anaconda3-2024.02-1-Linux-x86_64.sh
if [ ! -f "$ANACONDA_INSTALLER" ]; then
    echo ">> Downloading Anaconda..."
    wget https://repo.anaconda.com/archive/$ANACONDA_INSTALLER
fi

echo ">> Installing Anaconda..."
bash $ANACONDA_INSTALLER -b -p $HOME/anaconda3
eval "$($HOME/anaconda3/bin/conda shell.bash hook)"
conda init

# Reload shell to activate conda
source ~/.bashrc

# Step 6: Install Mamba
echo ">> Installing Mamba..."
conda install -y -n base -c conda-forge mamba

# Step 7: Create Conda environment for fastbook
echo ">> Creating Conda environment 'fastbook-env'..."
mamba create -y -n fastbook-env python=3.10
conda activate fastbook-env

# Step 8: Install fastai and Jupyter
echo ">> Installing fastai, jupyter, and other dependencies..."
mamba install -y -c fastai -c pytorch -c nvidia fastai jupyter notebook nb_conda_kernels ipywidgets

# Step 9: Clone the fastbook repository
echo ">> Cloning fastbook repo..."
git clone https://github.com/fastai/fastbook.git
cd fastbook

# Step 10: Install Jupyter kernel for the new env
python -m ipykernel install --user --name fastbook-env --display-name "Python (fastbook)"

# Step 11: Run test notebook
echo ">> Running test on clean.ipynb..."
jupyter nbconvert --to notebook --execute clean.ipynb --output test_output.ipynb

echo "=== Setup Complete! ==="
echo "You can now launch Jupyter with:"
echo "  conda activate fastbook-env"
echo "  jupyter notebook"
echo ""
echo "Note: A reboot may be required for NVIDIA drivers to take full effect."
