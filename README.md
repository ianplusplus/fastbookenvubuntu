# fastbookenvubuntu
*** NEEDS TO BE RUN CURRENTLY AFTER THE SCRIPT RUNS ***
mamba install "numpy<2" -y

1. System Update and Upgrade
Updates Ubuntu package lists and upgrades installed packages to their latest versions.

2. Installs Recommended NVIDIA Drivers
Detects and installs the best compatible NVIDIA GPU drivers for your system to enable CUDA support.

3. Downloads and Installs Miniconda
Installs Miniconda (a lightweight Conda installer) silently into your home directory.

4. Initializes Conda for Your Shell
Configures your shell environment to recognize Conda commands immediately.

5. Installs Mamba Package Manager
Installs Mamba, a fast alternative to Conda, for quicker environment creation and package management.

6. Removes Any Existing fastai Environment
Cleans up any previous fastai Conda environment to avoid conflicts.

7. Creates a New fastai Conda Environment
Sets up a fresh environment with Python 3.10 for your FastAI projects.

8. Installs FastAI and JupyterLab
Installs FastAI libraries and JupyterLab notebook server inside the environment.

9. Installs GPU-Enabled PyTorch and CUDA Toolkit
Installs PyTorch version 2.2 with CUDA 12.1 support from the official PyTorch and NVIDIA channels to enable GPU acceleration.

10. Installs FiftyOne via Pip
Adds FiftyOne (a tool for visualizing datasets) to the environment via pip.

11. Registers the Environment’s Python Kernel with Jupyter
Makes the fastai Conda environment selectable as a kernel inside Jupyter notebooks.

12. Initializes Mamba Shell Integration
Configures Mamba for future shell sessions for smoother usage.

****Currently this needs to be ran until other packages are updated to NumPy 2.0****

Downgrades NumPy to Version < 2
Ensures NumPy compatibility with PyTorch by installing a version below 2.0 to avoid runtime warnings/errors.

mamba install "numpy<2" -y
