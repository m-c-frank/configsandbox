#!/bin/sh
# Exit on error
set -e
# Define the repository URL
REPO_URL="https://github.com/m-c-frank/configsandbox"
# Clone the repository
git clone "$REPO_URL" configsandbox
# Change into the directory
cd configsandbox
# Run the installation script
chmod +x install.sh && ./install.sh
# Run the script to start the environment
chmod +x run.sh && ./run.sh
