#!/bin/bash

#update the system
sudo apt update && sudo apt upgrade -y

#install miniconda

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod u+x Miniconda3-latest-Linux-x86_64.sh

#This part may not work as intended, I will try this time

bash Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc

#install mamba

conda install mamba -n base -c conda-forge

#create an environment for fastai

mamba create -n fastai python=3.10 -c conda-forge
mamba activate fastai

#look into what this line does I am not actually quite sure, but it makes fastai activate in conda

eval "$(mamba shell hook --shell bash)"

mamba activate fastai

mamba shell init --shell bash --root-prefix=~/.local/share/mamba

exec bash

mamba activate fastai

pip install fiftyone

echo "To run Jupyter on LAN run the line jupyter lab --ip=0.0.0.0 --port=8888 --no-browser but replace the ip with yours"
