#!/bin/bash

#update the system
sudo apt update && sudo apt upgrade -y

#install miniconda

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod u+x Miniconda3-latest-Linux-x86_64.sh

#This part may not work as intended, I will try this time

bash Miniconda3-latest-Linux-x86_64.sh
