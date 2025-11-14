#!/usr/bin/env bash
set -e

# Prefer existing Miniforge if present
if [ -x "$HOME/miniforge/bin/conda" ]; then
  echo "Using existing Miniforge at $HOME/miniforge"
  source "$HOME/miniforge/bin/activate"

# Otherwise install Miniforge
else
  echo "Installing Miniforge..."
  wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh -O miniforge.sh
  bash miniforge.sh -b -p "$HOME/miniforge"
  rm miniforge.sh
  source "$HOME/miniforge/bin/activate"
fi

# Create or update environment
if conda env list | grep -q "^gr00t "; then
  echo "Updating existing gr00t env from env_gr00t.yml"
  conda env update -f env_gr00t.yml
else
  echo "Creating gr00t env from env_gr00t.yml"
  conda env create -f env_gr00t.yml
fi

conda activate gr00t

# Verify installation
python - << 'EOF'
import torch
print("Torch version:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("CUDA device:", torch.cuda.get_device_name(0))
EOF
