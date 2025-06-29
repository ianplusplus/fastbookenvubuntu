#!/bin/bash

set -e

echo "🚀 FastBook Setup Script (Ubuntu + GPU + Conda + fastai)"

# 1. Check & Install Miniconda
if ! command -v conda &> /dev/null; then
    echo "🔧 Installing Miniconda..."
    cd /tmp
    curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
    export PATH="$HOME/miniconda/bin:$PATH"
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
else
    echo "✅ Miniconda already installed"
fi

# 2. Install Mamba for faster conda ops
echo "🔧 Installing Mamba..."
conda install -y -n base -c conda-forge mamba

# 3. Create fastai environment
echo "🔧 Creating 'fastai' Conda environment..."
mamba create -n fastai -y python=3.10 pip

# 4. Activate environment
source ~/miniconda/bin/activate fastai

# 5. Install PyTorch with CUDA
echo "🔥 Installing PyTorch with CUDA..."
mamba install -y -c pytorch -c nvidia pytorch torchvision torchaudio pytorch-cuda=12.1

# 6. Install fastai + fastbook + common deps
echo "📘 Installing fastai + fastbook..."
mamba install -y -c fastai -c conda-forge fastai jupyter matplotlib scikit-learn pandas ipywidgets
pip install fastbook

# 7. Fix NumPy incompat if needed
echo "⚠️ Checking NumPy version compatibility..."
pip install "numpy<2"

# 8. GPU Check
echo "🧪 Verifying CUDA GPU:"
python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'None')"

# 9. NVIDIA Driver Check & Install
echo "🧰 Checking for NVIDIA driver..."
if ! command -v nvidia-smi &> /dev/null; then
    echo "🔧 Installing NVIDIA driver (will auto-select recommended)..."
    sudo apt update
    sudo apt install -y ubuntu-drivers-common
    sudo ubuntu-drivers install
    echo "⚠️ NVIDIA driver installed. Please reboot your computer now."
else
    echo "✅ NVIDIA driver already installed: $(nvidia-smi --query-gpu=driver_version --format=csv,noheader)"
fi

echo "✅ Setup complete! To activate your environment later, run:"
echo "   conda activate fastai"
