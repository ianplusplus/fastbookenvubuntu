#!/bin/bash
set -e

echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "📦 Downloading Miniconda installer..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

echo "💾 Installing Miniconda..."
chmod +x ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
rm ~/miniconda.sh

# Initialize conda for the shell
echo "🔄 Initializing Conda..."
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
$HOME/miniconda/bin/conda init
source ~/.bashrc

echo "⚡ Installing Mamba (fast Conda alternative)..."
conda install -n base -c conda-forge mamba -y

# Ensure mamba is properly hooked in this session
eval "$(mamba shell hook --shell bash)"

echo "📚 Creating FastAI environment..."
mamba create -n fastai python=3.10 fastai jupyterlab -c fastai -c pytorch -c conda-forge -y

echo "🚀 Activating FastAI environment..."
mamba activate fastai

echo "🧪 Installing FiftyOne (via pip)..."
pip install fiftyone

echo "🔁 Setting up mamba for future shell sessions..."
mamba shell init --shell bash --root-prefix=$HOME/.local/share/mamba

echo ""
echo "✅ All done! Your FastAI development environment is ready."
echo ""
echo "💡 To run JupyterLab on your LAN, use:"
echo "   jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
echo "   (Replace 0.0.0.0 with your machine's IP address if needed)"
