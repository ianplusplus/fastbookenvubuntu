#!/bin/bash
set -euo pipefail

ENV_NAME="fastai"

echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "🧰 Installing NVIDIA drivers (if needed)..."
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers autoinstall

echo "✅ NVIDIA driver setup complete. Please reboot after this script finishes."

echo "📦 Downloading Miniconda..."
wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

echo "💾 Installing Miniconda..."
bash ~/miniconda.sh -b -p $HOME/miniconda
rm ~/miniconda.sh

echo "🔄 Initializing Conda..."
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
$HOME/miniconda/bin/conda init
source ~/.bashrc

echo "⚡ Installing Mamba..."
conda install -n base -c conda-forge mamba -y
eval "$(mamba shell hook --shell bash)"

echo "🧹 Removing existing '$ENV_NAME' environment (if exists)..."
conda remove -n $ENV_NAME --all -y || true

echo "📚 Creating Conda environment '$ENV_NAME'..."
mamba create -n $ENV_NAME python=3.10 -y -c conda-forge

echo "🚀 Activating environment '$ENV_NAME'..."
conda activate $ENV_NAME

echo "📦 Installing FastAI, FastBook, JupyterLab, and dependencies..."
mamba install -y -c fastai -c conda-forge fastai fastbook jupyterlab ipywidgets matplotlib scikit-learn pandas

echo "⚙️ Installing GPU-enabled PyTorch (CUDA 12.1)..."
mamba install -y -c pytorch -c nvidia pytorch=2.2 torchvision=0.17 torchaudio pytorch-cuda=12.1

echo "🧪 Installing FiftyOne..."
pip install --upgrade pip
pip install fiftyone

echo "🔗 Registering environment kernel for Jupyter..."
python -m ipykernel install --user --name $ENV_NAME --display-name "Python ($ENV_NAME)"

echo "📚 Downloading FastBook datasets..."
python -c "from fastbook import *; setup_book()"

echo "🌀 Initializing Mamba for future shell sessions..."
mamba shell init --shell bash --root-prefix=$HOME/.local/share/mamba

echo ""
echo "✅ All done! Your GPU-powered FastBook + FastAI + FiftyOne environment is ready."
echo "🔁 Please reboot your machine now to activate NVIDIA drivers if this is the first install."
echo ""
echo "🚀 To start working:"
echo "   conda activate $ENV_NAME"
echo "   jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
echo ""
echo "💡 FastBook notebooks are now ready to use — run them without errors!"
