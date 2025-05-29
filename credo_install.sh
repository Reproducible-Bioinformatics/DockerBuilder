#!/bin/bash
set -e

echo "📁 Creating and moving to /credo_env..."
mkdir -p /credo_env && cd /credo_env

echo "📦 Installing packages with CREDO pip..."
apt-get update -y

echo "+ credo pip pandas"
credo pip pandas

echo "+ credo pip numpy"
credo pip numpy

echo "+ credo pip scikit-learn"
credo pip scikit-learn

echo "+ credo pip tensorflow"
credo pip tensorflow

echo "+ credo pip jupyterlab"
credo pip jupyterlab

echo "✅ Done with credo pip commands."

