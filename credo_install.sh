#!/bin/bash
set -e
apt-get update
echo "📁 Creating and moving to /credo_env..."
mkdir -p /credo_env && cd /credo_env

echo "📦 Installing packages with CREDO pip..."

credo pip pandas
credo pip numpy
credo pip scikit-learn
credo pip tensorflow
credo pip jupyterlab
credo bioconductor GenomicRanges
echo "✅ Done with credo pip commands."
credo save
