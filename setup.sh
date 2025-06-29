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

echo "🔄 Initializing Conda shell..."
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
$HOME/miniconda/bin/conda init
source ~/.bashrc

# --- Install Mamba ---
echo "⚡ Installing Mamba..."
mamba install -n base -c conda-forge mamba -y
eval "$(mamba shell hook --shell bash)"

# Optional: Install nodejs for JupyterLab extensions to avoid warnings
echo "🌐 Installing NodeJS for JupyterLab..."
mamba install -n base -c conda-forge nodejs -y

# --- Clean Existing Env ---
echo "🧹 Removing old fastai env if exists..."
mamba remove -n fastai --all -y || true

# --- Create New Env ---
echo "📚 Creating FastAI env..."
mamba create -n fastai python=3.10 -y -c conda-forge

echo "🚀 Activating fastai environment..."
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
conda activate fastai

# --- Remove any existing PyTorch before reinstalling ---
echo "🧹 Removing old PyTorch packages if any..."
mamba remove pytorch torchvision torchaudio pytorch-cuda -y || true

# --- Install FastAI + JupyterLab + PyTorch + CUDA ---
echo "📦 Installing FastAI, JupyterLab, PyTorch w/ CUDA (NumPy <2)..."
mamba install fastai jupyterlab "numpy<2" -c fastai -c conda-forge -y
mamba install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia -y --force-reinstall

# --- Continue with pip installs ---
echo "📘 Installing fastbook..."
pip install fastbook --quiet

echo "🧪 Installing FiftyOne..."
pip install fiftyone --quiet

echo "🔍 Confirming NumPy version..."
python -c "import numpy; print('✅ NumPy version in use:', numpy.__version__)"

echo "🔗 Registering environment kernel for Jupyter..."
python -m ipykernel install --user --name fastai --display-name "Python (fastai)"

# --- Clone fastbook repo only if not exists ---
BOOK_DIR=~/fastbook
if [ ! -d "$BOOK_DIR" ]; then
  echo "📁 Cloning fastbook repo with notebooks..."
  git clone https://github.com/fastai/fastbook.git "$BOOK_DIR"
else
  echo "Fastbook directory already exists. Skipping clone."
fi

echo "📦 Downloading datasets (using setup_book)..."
cd "$BOOK_DIR"
conda run -n fastai python -c "from fastbook import *; setup_book()"

echo "🌀 Setting up Mamba shell config..."
mamba shell init --shell bash --root-prefix=$HOME/.local/share/mamba

echo ""
echo "✅ FastAI + Fastbook environment is ready!"
echo "🔁 Please REBOOT your machine now to activate the NVIDIA driver."
echo ""
echo "💡 To launch JupyterLab:"
echo "   conda activate fastai"
echo "   jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
echo ""
