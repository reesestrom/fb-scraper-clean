#!/bin/bash

# Install Node dependencies
npm install

# Download latest Chrome-for-Testing (Linux 64-bit)
mkdir -p chrome
cd chrome
curl -O https://storage.googleapis.com/chrome-for-testing-public/117.0.5938.92/linux64/chrome-linux64.zip
unzip chrome-linux64.zip
mv chrome-linux64 chrome
chmod +x chrome/chrome
