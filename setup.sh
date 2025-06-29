#!/bin/bash
set -euo pipefail

ENV_NAME="fastai"
BOOK_DIR="$HOME/fastbook"

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
conda activate $ENV_NAME

echo "📦 Installing FastAI, FastBook, and JupyterLab..."
mamba install -y -c fastai -c conda-forge fastai fastbook jupyterlab ipywidgets matplotlib scikit-learn pandas

echo "⚙️ Installing GPU-enabled PyTorch (CUDA 12.1)..."
mamba install -y -c pytorch -c nvidia \
    pytorch=2.2 torchvision=0.17 torchaudio pytorch-cuda=12.1

echo "🧪 Installing FiftyOne..."
pip install --upgrade pip
pip install fiftyone

echo "🔗 Registering environment kernel for Jupyter..."
python -m ipykernel install --user --name $ENV_NAME --display-name "Python ($ENV_NAME)"

echo "📁 Cloning fastbook repo with notebooks..."
git clone https://github.com/fastai/fastbook.git "$BOOK_DIR" || {
    echo "📁 fastbook directory already exists. Pulling latest changes..."
    cd "$BOOK_DIR" && git pull
}

echo "📦 Downloading datasets (using setup_book)..."
cd "$BOOK_DIR"
python -c "from fastbook import *; setup_book()"

echo "🌀 Initializing Mamba for future shell sessions..."
mamba shell init --shell bash --root-prefix=$HOME/.local/share/mamba

echo ""
echo "✅ All done! Your GPU-powered FastBook + FastAI + FiftyOne environment is ready."
echo "📘 Notebooks are in: $BOOK_DIR"
echo "🔁 Please reboot your machine now to activate NVIDIA drivers (if this is the first time)."
echo ""
echo "🚀 To start working:"
echo "   conda activate $ENV_NAME"
echo "   cd ~/fastbook"
echo "   jupyter lab"
