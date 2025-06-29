#!/bin/bash
set -e

echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "🧰 Installing recommended NVIDIA driver..."
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers autoinstall

echo "✅ NVIDIA driver installed. Please reboot your system after this script finishes."

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

echo "⚡ Installing Mamba..."
conda install -n base -c conda-forge mamba -y
eval "$(mamba shell hook --shell bash)"

echo "🧹 Removing any old fastai environment if it exists..."
conda remove -n fastai --all -y || true

echo "📚 Creating new FastAI environment with CUDA support..."
mamba create -n fastai python=3.10 -y -c conda-forge

echo "🚀 Activating environment..."
conda activate fastai

echo "📦 Installing FastAI and JupyterLab..."
mamba install fastai jupyterlab -c fastai -c conda-forge -y

echo "⚙️ Installing GPU-enabled PyTorch (CUDA 12.1)..."
mamba install pytorch=2.2 torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia -y

echo "🧪 Installing FiftyOne via pip..."
pip install fiftyone

echo "🔗 Registering environment for Jupyter..."
python -m ipykernel install --user --name fastai --display-name "Python (fastai)"

echo "🌀 Setting up Mamba for future shell sessions..."
mamba shell init --shell bash --root-prefix=$HOME/.local/share/mamba

echo ""
echo "✅ All done! Your GPU-ready FastAI development environment is ready."
echo "🔁 Please reboot your machine now to activate the NVIDIA driver."
echo ""
echo "💡 To run JupyterLab on your LAN, use:"
echo "   jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
echo "   (Replace 0.0.0.0 with your machine's IP if needed)"
