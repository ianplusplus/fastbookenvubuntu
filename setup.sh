#!/bin/bash
set -e

# --- Update System ---
echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# --- NVIDIA Driver ---
echo "🧰 Installing recommended NVIDIA driver..."
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers autoinstall || true
echo "✅ NVIDIA driver install step complete. Reboot will be required."

# --- Install Miniconda ---
echo "📦 Downloading Miniconda installer..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

echo "💾 Installing Miniconda..."
chmod +x ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
rm ~/miniconda.sh

echo "🔄 Initializing Conda..."
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
$HOME/miniconda/bin/conda init
source ~/.bashrc

# --- Install Mamba ---
echo "⚡ Installing Mamba..."
conda install -n base -c conda-forge mamba -y
eval "$(mamba shell hook --shell bash)"

# --- Clean Existing Env ---
echo "🧹 Removing old fastai env if exists..."
conda remove -n fastai --all -y || true

# --- Create New Env ---
echo "📚 Creating FastAI env..."
mamba create -n fastai python=3.10 -y -c conda-forge

echo "🚀 Activating env..."
conda activate fastai

# --- Install FastAI + JupyterLab + PyTorch + CUDA ---
echo "📦 Installing FastAI, JupyterLab, PyTorch w/ CUDA..."
mamba install fastai jupyterlab -c fastai -c conda-forge -y
mamba install pytorch=2.2 torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia -y

# --- Install Fastbook Python package ---
echo "📘 Installing fastbook..."
pip install fastbook --quiet

# --- Install FiftyOne via pip ---
echo "🧪 Installing FiftyOne..."
pip install fiftyone --quiet

# --- Register kernel with Jupyter ---
echo "🔗 Registering environment kernel for Jupyter..."
python -m ipykernel install --user --name fastai --display-name "Python (fastai)"

# --- Clone fastbook notebook repo ---
echo "📁 Cloning fastbook repo with notebooks..."
BOOK_DIR=~/fastbook
git clone https://github.com/fastai/fastbook.git "$BOOK_DIR"

# --- Download datasets ---
echo "📦 Downloading datasets (using setup_book)..."
cd "$BOOK_DIR"
conda run -n fastai python -c "from fastbook import *; setup_book()"

# --- Mamba Shell Config ---
echo "🌀 Setting up Mamba shell config..."
mamba shell init --shell bash --root-prefix=$HOME/.local/share/mamba

# --- Done ---
echo ""
echo "✅ FastAI + Fastbook environment is ready!"
echo "🔁 Please REBOOT your machine now to activate the NVIDIA driver."
echo ""
echo "💡 To launch JupyterLab:"
echo "   conda activate fastai"
echo "   jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
echo ""
